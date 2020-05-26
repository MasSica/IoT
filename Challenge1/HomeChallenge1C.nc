/* Home Challenge 1 C file

Mondal Arnab, Pezzoli Carlo, Sica Massimiliano */

#include "HomeChallenge1.h"
#include "Timer.h"

/* In the following 3 MACROs, we define the IDs corresponding to our motes. This is useful because if in the future we have motes with different IDs, we can reuse this code only changing the IDs in this 3 MACROs, without modify the rest of the code.
*/
#define id1 1
#define id2 2
#define id3 3


module HomeChallenge1C @safe() {

	uses {
	    interface Boot;
		interface Leds;
		interface Timer<TMilli> as Timer;
		interface Receive as Receiver;
		interface AMSend as Sender;
		interface SplitControl as AMControl;
		interface Packet;  
	}
  
}


implementation {

	message_t packet;  
	bool locked;
	uint16_t counter = 0;

  
    event void Boot.booted() {					//At boot AMControl is started.
  
    	call AMControl.start();

    }
  

    event void AMControl.startDone(error_t err) {	//If AMControl started successfully, we set the timers. Otherwise, restarted.

        if (err == SUCCESS) {						//Note: different timers for different motes (depends on their ID).
    	
    	    if(TOS_NODE_ID==id1){
				call Timer.startPeriodic(1000);		// 1Hz
    		}
     		else if(TOS_NODE_ID==id2){
     			call Timer.startPeriodic(333);		// 3 Hz
     		}     
     		else if(TOS_NODE_ID==id3){
     			call Timer.startPeriodic(200);		// 5 Hz
     		}
     	 
    	}
    
    	else {
        	call AMControl.start();   
    	}
    
	}


	event void AMControl.stopDone(error_t err) {	//When AMControl id stopped.
	
		//Do nothing.   
    
	}
  
  
  	event void Timer.fired() {		//When timer fires, counter increased by one. Packet is built and sent.
  	   
    	counter++;
    	
	    if (locked) {	//We can't send a Packet if event SendDone of previous one not yet appeared (see last event of this code)
    	  return;
    	}
		else {
        	radio_msg_t* rm = (radio_msg_t*)call Packet.getPayload(&packet, sizeof(radio_msg_t));	//Creates Packet
        	if (rm == NULL) {
				return;
    		}
      		rm->counter = counter; 			//Counter stored in the packet
      		rm->sourceid = TOS_NODE_ID;		//As well as the ID of the NODE that sends it 
      		if (call Sender.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_msg_t)) == SUCCESS) { //Transmit packet and set locked
				locked = TRUE;
      		}
    	}
    	
	}  
  

	event message_t* Receiver.receive(message_t* bufPtr,void* payload, uint8_t len) {	//Event occours when a packet is received
  
	    if (len != sizeof(radio_msg_t)) {				//Check if packet is valid
	    	return bufPtr;
	    }      
	    else {											//Turn Leds on and off according to our rules.
	    	radio_msg_t* rm = (radio_msg_t*)payload;     
      
	    	if(rm->counter % 10 == 0){
	    		call Leds.led0Off();
	      		call Leds.led1Off();
	      		call Leds.led2Off();
	      	}
	      	else if (rm->sourceid == id1 ) {    
				call Leds.led0Toggle();
	      	}	      
	      	else if (rm->sourceid == id2) {
				call Leds.led1Toggle();
	      	}	      
	      	else if (rm->sourceid == id3) {
				call Leds.led2Toggle();
	      	}     
	      
	      	return bufPtr;
	    }
	    
	}
	
	
	event void Sender.sendDone(message_t* bufPtr, error_t error) {		//Response to an accepted send request
	    if (&packet == bufPtr) {
	    	locked = FALSE;
	    }
	}
	

}
