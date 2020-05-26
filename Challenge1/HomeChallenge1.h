/* Home Challenge 1 library file

Mondal Arnab, Pezzoli Carlo, Sica Massimiliano */

#ifndef HOME_CHALLENGE_1_H
#define HOME_CHALLENGE_1_H

//Definition of messages' structure

typedef nx_struct radio_msg{
	
	nx_uint16_t counter;			//Field of the counter
	nx_uint16_t sourceid;			//Field of the sender id
	
} radio_msg_t;


enum {
	AM_RADIO_MSG = 6,
};


#endif
