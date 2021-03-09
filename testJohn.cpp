/* Cosmic-ray Test Simulation Platform
*
*  Reference : example/basic/B5
*
*  Author : ytwu (torrence@mail.ustc.edu.cn)
*
*  Created : 2017.02.17
*
*/

/* file : CRTest.cxx
** desc.: Main Program for CRTest
*/

#include "Argument.hh"
#include "SysConstruction.hh"
#include "GdmlConstruction.hh"
#include "ActionRegister.hh"
#include "SysMessenger.hh"
#include "PhysicsList.hh"

#include "G4RunManager.hh"
#include "G4UImanager.hh"
#include "G4UIExecutive.hh"
#include "G4VisExecutive.hh"

#include "G4VModularPhysicsList.hh"
#include "G4StepLimiterPhysics.hh"

#include "globals.hh"
#include "G4ios.hh"
#include <cstdlib>

#include "PduGenerator.hh"
#include "TFile.h"
#include "TTree.h"

int main(int argc, char **argv)
{
	// Handle Arguments
	Argument args;
	if (!args.Build(argc, argv)) //Build(argc,argv)处理命令行参数，将执行程序，gdml读出
	{
		args.Usage(); //G4cout << " Usage : ./CRTest [.gdml] [.mac] [output] [seed]"<< G4endl;
		return -1;
	}
	// UI Session   //定义是否使用UI界面，还是直接命令行跑
	std::cout << CLHEP::ns << std::endl;

	// Random
	G4Random::setTheEngine(new CLHEP::RanecuEngine);
	G4Random::setTheSeed(args.RndSeed(), 3);
	// Run manager
	G4RunManager *runManager = new G4RunManager;
	runManager->SetUserInitialization(new GdmlConstruction(args.Gdml()));
	// Physics List
	runManager->SetUserInitialization(new PhysicsList);
	// User Actions
	runManager->SetUserInitialization(new ActionRegister);
	// User Messenger
	SysMessenger *messenger = new SysMessenger(runManager);

	std::cout << "Gev: " << CLHEP::GeV << std::endl;
	auto file = new TFile("testPdu.root", "recreate");
	auto tree = new TTree("pdu", "pdu");
	double theta, phi, Ek;
	tree->Branch("theta", &theta, "theta/D");
	tree->Branch("phi", &phi, "phi/D");
	tree->Branch("Ek", &Ek, "Ek/D");
	PduGenerator pduGen;
	for (int i = 0; i < 100000; i++)
	{
		if (i % 1000 == 0)
			std::cout << i << std::endl;
		pduGen.GeneratePrimaryToy(theta, phi, Ek);
		tree->Fill();
	}
	tree->Write();
	file->Close();

	return 0;
}