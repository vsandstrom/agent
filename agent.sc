Agent { 
	var <>freq, <>fb, <>pos, trig = 0;
	var synth;


	*new{ | freq, fb, pos | // gets arguments on creation of instance.
		^super.new.init(freq, fb, pos);

	}

	init { | freq, fb, pos |	// Takes the class arguments and assigns them to class variables. 
		this.freq = freq;
		this.fb = fb;
		this.pos = pos;

								// Create new synth using values in class variables.

		this.synth = Synth(\agent, [\freq, this.freq, \fb, this.fb, \pos, this.pos, \t_trig, 1]);

	}

	setInstance { | freq, pos, fb | // Sets new values to class variables.
		this.freq = freq; 
		this.pos = pos;
		this.fb = fb;
									// Creates a new Synth instance with updated values.
		this.synth = Synth(\agent, [\freq, freq, \fb, fb, \pos, pos, \t_trig, 1]);

	}

	play {  // Unnecessary class method.
		this.trig_(1);
		this.synth.set(\t_trig, this.trig);
	}

	reset { // Also Unnecessary.
		this.trig_(0);
		this.synth.set(\t_trig, this.trig);
	}
	
}
