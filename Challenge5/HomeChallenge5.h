/* Home Challenge 5 library file

Mondal Arnab, Pezzoli Carlo, Sica Massimiliano */

#ifndef HOME_CHALLENGE_5_H
#define HOME_CHALLENGE_5_H

//Definition of messages' structure

typedef nx_struct radio_msg{
	
	nx_uint16_t value;			//Field of the random value
	nx_uint16_t topic;			//Field of the static topic
	
} radio_msg_t;


enum {
	AM_RADIO_MSG = 6,
};


#endif
