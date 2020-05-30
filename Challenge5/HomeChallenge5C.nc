/* Home Challenge 5 C file

Mondal Arnab, Pezzoli Carlo, Sica Massimiliano */

#include "HomeChallenge5.h"
#include "Timer.h"
#include "printf.h"

/* In the following 3 MACROs, we define the IDs corresponding to our motes. This is useful because if in the future we have motes with different IDs, we can reuse this code only changing the IDs in this 3 MACROs, without modify the rest of the code.
*/
#define id1 1
#define id2 2
#define id3 3


module HomeChallenge5C @safe() {

	uses {
	    interface Boot;
		interface Random;
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

  
    event void Boot.booted() {					//At boot AMControl is started.
  
    	call AMControl.start();

    }
  

    event void AMControl.startDone(error_t err) {	//If AMControl started successfully, we set the timers. Otherwise, restarted.

        if (err == SUCCESS) {
    	
    	    if(TOS_NODE_ID==id2 || TOS_NODE_ID==id3){
				call Timer.startPeriodic(5000);		//For mote 2 and 3 we start a timer with period 5 seconds.
    		}
    	}
    
    	else {
        	call AMControl.start();   
    	}
    
	}


	event void AMControl.stopDone(error_t err) {	//When AMControl id stopped.
	
		//Do nothing.   
    
	}
  
  
  	event void Timer.fired() {		//When timer fires, packet is built and sent.
    	
	    if (locked) {	//We can't send a Packet if event SendDone of previous one not yet appeared (see last event of this code)
    	  return;
    	}
		else {
        	radio_msg_t* rm = (radio_msg_t*)call Packet.getPayload(&packet, sizeof(radio_msg_t));	//Creates Packet
        	if (rm == NULL) {
				return;
    		}
      		rm->value = (call Random.rand16()%101); 			//Random value stored in the packet
      		if(TOS_NODE_ID==id2){
      			rm->topic = 1;					//We set a different topic for different mote
      		}
      		else if(TOS_NODE_ID==id3){
      			rm->topic = 2;
      		}
      		if (call Sender.send(id1, &packet, sizeof(radio_msg_t)) == SUCCESS) { //Transmit packet and set locked
				locked = TRUE;
      		}
    	}
    	
	} 
  

	event message_t* Receiver.receive(message_t* bufPtr,void* payload, uint8_t len) {
	//Since only motes 2 and 3 sends messages to mote 1, only mote 1 will use this function
  		if (TOS_NODE_ID==id1){
	    	if (len != sizeof(radio_msg_t)) {				//Check if packet is valid
	    		return bufPtr;
	    	}      
	    	else {											//Print the messages coming from mote 1 and 3
	    		radio_msg_t* rm = (radio_msg_t*)payload;
	    		printf("Value:_%u_,Topic:_%u_\n", rm->value, rm->topic);     
	      		printfflush();
	      		return bufPtr;
	      	}
	    }    
	}
	
	
	event void Sender.sendDone(message_t* bufPtr, error_t error) {		//Response to an accepted send request
	    if (&packet == bufPtr) {
	    	locked = FALSE;
	    }
	}
	

}
