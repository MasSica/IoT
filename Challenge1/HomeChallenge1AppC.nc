/* Home Challenge 1 AppC file

Mondal Arnab, Pezzoli Carlo, Sica Massimiliano */

#include "HomeChallenge1.h"

configuration HomeChallenge1AppC {}

implementation {

	components MainC, LedsC, ActiveMessageC, HomeChallenge1C as App;
	components new TimerMilliC();
	components new AMSenderC(AM_RADIO_MSG);
	components new AMReceiverC(AM_RADIO_MSG);
	
	App.Boot -> MainC.Boot;
	App.Leds -> LedsC;
	App.Timer -> TimerMilliC;
	App.Receiver -> AMReceiverC;
	App.Sender -> AMSenderC;		
	App.AMControl -> ActiveMessageC;
	App.Packet -> AMSenderC;
	
}
