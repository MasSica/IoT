/* Home Challenge 5 AppC file

Mondal Arnab, Pezzoli Carlo, Sica Massimiliano */

#include "HomeChallenge5.h"

configuration HomeChallenge5AppC {}

implementation {

	components MainC, RandomC, ActiveMessageC, HomeChallenge5C as App;
	components new TimerMilliC();
	components new AMSenderC(AM_RADIO_MSG);
	components new AMReceiverC(AM_RADIO_MSG);
	components PrintfC;
    components SerialStartC;
	
	App.Boot -> MainC.Boot;
	App.Random -> RandomC;
	App.Timer -> TimerMilliC;
	App.Receiver -> AMReceiverC;
	App.Sender -> AMSenderC;		
	App.AMControl -> ActiveMessageC;
	App.Packet -> AMSenderC;
	
}
