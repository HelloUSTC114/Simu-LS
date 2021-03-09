/*
*   File : CRTest/inc/Generator.hh
*
*   Brief: Generate primary event vertex and define messenger commands
*
*/

#ifndef CRTest_Generator_h
#define CRTest_Generator_h

#include "G4VUserPrimaryGeneratorAction.hh"

#include "G4ParticleGun.hh"
#include "G4Event.hh"

class Generator : public G4VUserPrimaryGeneratorAction {

public:
  Generator();
  virtual ~Generator();
public:
  virtual void GeneratePrimaries(G4Event* anEvent); // Required by pure virtual class

protected:
  virtual void Generate();  // Generate position & direction & KineticEnergy
  virtual void GeneratePosition();  // Position is uniformly distributed in direction X&Y, and Z position is fixed
  virtual void GenerateDirection(); // Direction is set at (0,0,1), which towards z
  virtual void GenerateKineticEnergy(); // 3GeV

  G4ThreeVector GetWorldBoundary();
  G4bool CheckEndpoint(G4double boundaryZ);
protected:
  G4ParticleGun* fParticleGun;

  // Trigger Mode: Trigger modes means generates 10000 particles positions only, do not generate primary vertex, and calculate efficiency
  G4bool fTriggerMode;
  G4double fXmin;
  G4double fXmax;
  G4double fYmin;
  G4double fYmax;

public: // Get & Set method
  G4bool IsTriggerMode(){return fTriggerMode;};
  void SetTriggerMode(G4bool trigger){fTriggerMode = trigger;};
  G4double GetXmin(){return fXmin;};
  void SetXmin(G4double xmin){fXmin = xmin;};
  G4double GetXmax(){return fXmax;};
  void SetXmax(G4double xmax){fXmax = xmax;};
  G4double GetYmin(){return fYmin;};
  void SetYmin(G4double Ymin){fYmin = Ymin;};
  G4double GetYmax(){return fYmax;};
  void SetYmax(G4double Ymax){fYmax = Ymax;};
};

#endif /*CRTest_Generator_h*/