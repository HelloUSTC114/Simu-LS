/**
*   FILE : CRTest/src/StepAction.cc
*   Brief: Implementation of class StepAction
*/

#include "StepAction.hh"

#include "Analysis.hh"
#include "OpRecorder.hh"
#include "MuonRecorder.hh"

#include "CryPositionSD.hh"

#include "G4Step.hh"
#include "G4StepPoint.hh"
#include "G4Track.hh"
#include "G4SteppingManager.hh"
#include "G4VPhysicalVolume.hh"

#include "G4ParticleDefinition.hh"
#include "G4OpticalPhoton.hh"
#include "G4OpBoundaryProcess.hh"

#include "G4SystemOfUnits.hh"

StepAction::StepAction()
{
}

StepAction::~StepAction()
{
    G4cout << "[-] INFO - StepAction deleted. " << G4endl;
}

void StepAction::UserSteppingAction(const G4Step *aStep)
{

    OpRecorder *Recorder = OpRecorder::Instance();

    G4Track *theTrack = aStep->GetTrack();
    G4StepPoint *thePrePoint = aStep->GetPreStepPoint();
    G4StepPoint *thePostPoint = aStep->GetPostStepPoint();
    G4VPhysicalVolume *thePrePV = thePrePoint->GetPhysicalVolume();
    G4VPhysicalVolume *thePostPV = thePostPoint->GetPhysicalVolume();

    const G4VProcess *theProcess = fpSteppingManager->GetfCurrentProcess();
	// std::cout << theTrack->GetParticleDefinition()->GetParticleName() << std::endl;

	// for Muon (primary track)
	if (theTrack->GetParentID() == 0){
		MuonRecorder::Instance()->Record(theTrack);
		
		// TODO : #ifndef CRTest_Optical_Test -> primary == OpticalPhoton
		// Check if Muon in CryPositionSD
		G4TouchableHistory* touchable
			= (G4TouchableHistory*)(thePrePoint->GetTouchable());
		for(int i = 0 ; i < 10 ; i ++){
			G4VPhysicalVolume* pv = touchable->GetVolume(i);
			G4LogicalVolume* lv = pv->GetLogicalVolume();
			if(lv->GetName() == "World") break;
			
			G4VSensitiveDetector* sd = lv->GetSensitiveDetector();
			if(sd && sd->GetName() == "CryPositionSD")
				static_cast<CryPositionSD*>(sd)->ProcessHits_more(aStep,pv);
		}
	}

    //  for Optical
    if (theTrack->GetParticleDefinition() !=
        G4OpticalPhoton::OpticalPhotonDefinition())
        return;

	// Step Numbers CUT - to avoid endless OpBoundary process
	if(theTrack->GetCurrentStepNumber() > 5000){
		theTrack->SetTrackStatus(G4TrackStatus::fStopAndKill);
		Analysis::Instance()->FillOpPhotonTrackForDebug(theTrack, OpDebug);
		return;
	}
	// DEBUG - ABSLENGTH
	if(theProcess->GetProcessName() == "OpAbsorption")
		Recorder->nDebug += 1;

    //
    // Boundary Check
    //
	// static int a = 0;
	// if(!thePrePV&&!thePostPV)
	// {
	// 	std::cout<< "No Pre/Post: " << theTrack->GetParticleDefinition()->GetParticleName() << a++ << std::endl;

	// }
	// if(thePrePV&&!thePostPV)
	// {
	// 	std::cout<< "No Post: " << theTrack->GetParticleDefinition()->GetParticleName() << '\t' << thePrePV->GetName() << '\t' << a++ << std::endl;
	// }
	// if(!thePrePV&&thePostPV)
	// {
	// 	std::cout<< "No Pre: " << theTrack->GetParticleDefinition()->GetParticleName() << '\t' << thePostPV->GetName() << '\t' << a++ << std::endl;
	// }
	// if(thePrePV&&thePostPV)
	// {
	// 	std::cout<< "Normal: " << theTrack->GetParticleDefinition()->GetParticleName() << '\t' << thePostPV->GetName() << '\t' << thePrePV->GetName() << '\t' << a++ << std::endl;
	// }



	
	OpPhotonType type = OpPhotonType::Nothing;
    if (thePostPoint->GetStepStatus() == fGeomBoundary)
	{
        assert(theProcess->GetProcessName() == "OpBoundary");
        G4OpBoundaryProcess *boundary = (G4OpBoundaryProcess *)theProcess;
		G4OpBoundaryProcessStatus status = boundary->GetStatus();
		G4bool gotThrough = 
			(status == Transmission || status == FresnelRefraction);
		G4bool fromWLS = false;
		if(theTrack->GetParentID() != 0)
			fromWLS = (theTrack->GetCreatorProcess()->GetProcessName()
			== "OpWLS");
		if(gotThrough && !fromWLS){
			// OpPthoton got through boundary
			// if (thePrePV->GetName() == "Scintillator_PV" && thePostPV->GetName() == "Groove_PV")
			if ((thePrePV->GetName().find("Scin")!=G4String::npos) && (thePostPV->GetName().find("Groove")!=G4String::npos))
			{
				type = Scint2Groove;
				Recorder->nScint2Groove ++;

			}
			else if ((thePrePV->GetName().find("Groove")!=G4String::npos) && (thePostPV->GetName() .find( "Fiber")!=G4String::npos || thePostPV->GetName() .find( "Cladding2")!=G4String::npos))
			{
				type = Groove2Cladding;
				Recorder->nGroove2Cladding += 1;
			}
			else if ((thePrePV->GetName().find("Scin")!=G4String::npos) && (thePostPV->GetName() .find( "Fiber")!=G4String::npos || thePostPV->GetName() .find( "Cladding2")!=G4String::npos))
			{
				type = Scint2Cladding;
				Recorder->nScint2Cladding += 1;

			}
			else if (thePrePV->GetName() .find( "Cladding1")!=G4String::npos && thePostPV->GetName() .find( "Core")!=G4String::npos)
			{
				type = Cladding2Core;
				Recorder->nCladding2Core += 1;
			}
			// For Debug boundary details
			else if ((thePrePV->GetName() .find( "Cladding1")!=G4String::npos ||  thePrePV->GetName() .find( "Cladding2")!=G4String::npos ) && thePostPV->GetName() .find( "Groove")!=G4String::npos)
			{
				Recorder->SetBoundaryName("Fiber2Groove");
				BoundaryStats(boundary);
				return;
			}
		}
        else if (thePrePV->GetName() .find( "Fiber")!=G4String::npos && thePostPV->GetName() .find( "PMT")!=G4String::npos)
        {
			// OpPhoton hit PMT photocathode
            type = Fiber2Pmt;
            Recorder->nCore2PMT += 1;
            if (status == Detection){
				type = Detected;
				Recorder->nDetection += 1;
			}
        }
    }
	Analysis::Instance()->FillOpPhotonTrackForDebug(theTrack, type);
}

G4bool StepAction::BoundaryStats(G4OpBoundaryProcess *boundary)
{
    OpRecorder *Recorder = OpRecorder::Instance();
    switch (boundary->GetStatus())
    {
    case FresnelRefraction:;
    case Transmission:
        Recorder->nBoundaryTransmission++;
        break;
    case Absorption:;
    case Detection:
        Recorder->nBoundaryAbsorption++;
        break;
    case FresnelReflection:;
    case TotalInternalReflection:;
    case LambertianReflection:;
    case LobeReflection:;
    case SpikeReflection:;
    case BackScattering:
        Recorder->nBoundaryReflection++;
        break;
    case Undefined:
        Recorder->nBoundaryUndefined++;
        break;
    case NotAtBoundary:;
    case SameMaterial:;
    case StepTooSmall:;
    case NoRINDEX:;
        Recorder->nBoundaryWARNNING++;
        break;
    default:
        return false;
    }
    return true;
}