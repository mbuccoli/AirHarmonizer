// Settings per cambiare input audio

//Server.local.options.inDevice = "MME : Cuffie (Audio Bluetooth)";
//Server.local.options.outDevice = " MME : Cuffie (Audio Bluetooth)";
Server.local.options.inDevice = "[Scarlett 2i2 USB]";
Server.local.options.outDevice = "[Scarlett 2i2 USB]";
ServerOptions.outDevices

// Player
(
 SynthDef(\harm,
	{

		// p1, p2, p3 sono gli argomenti per i pitch;
		// g1, g2, g3 sono gli argomenti per i gain
		//arg p1 = 1.0, p2 = 1.0, p3 = 1.0, g1 = 1.0, g2 = 1.0, g3 = 1.0;
		//arg g1 =1.0, g2 = 1.0, g3 = 1.0, g4 = 1.0, g5 = 1.0;
		arg g1 =0, g2 = 0, g3 = 0, g4 = 0, g5 = 0;

		var wS=0.1;
		var p1 =0.5, p2 = 0.75, p3 = 1.333333, p4 = 1.5, p5 = 2;
		var out_signal;

		// fai QUESTO se vuoi usare il file vocals (cambialo a seconda del tuo path assoluto
		//var infile="/Users/Clara/Desktop/AirHarmonizer/vocals.wav";
		//var b = Buffer.read(s, infile);
		//var input=PlayBuf.ar(2,b.bufnum,BufRateScale.kr(b.bufnum),loop:1);

		// decommenta questo se vuoi invece l'input del microfono
		//var input=AudioIn.ar([1,2]);
		var input=AudioIn.ar(1);


		//var o1=PitchShift.ar(input,windowSize:wS,pitchRatio:p1);
		//var o2=PitchShift.ar(input,windowSize:wS,pitchRatio:p2);
		//var o3=PitchShift.ar(input,windowSize:wS,pitchRatio:p3);
		var o1=PitchShift.ar(input,windowSize:wS,pitchRatio:p1);
		var o2=PitchShift.ar(input,windowSize:wS,pitchRatio:p2);
		var o3=PitchShift.ar(input,windowSize:wS,pitchRatio:p3);
		var o4=PitchShift.ar(input,windowSize:wS,pitchRatio:p4);
		var o5=PitchShift.ar(input,windowSize:wS,pitchRatio:p5);



		//var out_signal=input+(o1*g1)+(o2*g2)+(o3*g3);//o1+o2+o3;//
		out_signal=(input*0.2)+((o1*g1)+(o2*g2)+(o3*g3)+(o4*g4)+(o5*g5))*0.8;

		//var out_signal=input*0.5+((o5*g5))*0.5;

		//var out_signal = input + o*g;
		Out.ar([0,1], out_signal);

 }).add;
)



// prova Senza OSC
// (
// a = Synth(\harm);
// a.set(\p1, 0.5,\g1,1, \p2,1, \g2,0.5, \g3,0);
// )


// prova OSC
NetAddr("127.0.0.1",57120);

(
var song, freq, loud,pan;


a = Synth(\harm);
//a.set(\p1, 1,\p2,1, \p3,2);


OSCdef('OSCreceiver',
	{
		arg msg;
		var gg1,gg2,gg3,gg4,gg5;
		//var pp;
		//var whichHarm = msg[1];
		//var gg = msg[2];
		//var gain;


		//whichHarm.postln();

		//pp = ratios[whichHarm];

		//if(gg==0,{gain=0},{gain=(gg-400)/(40-400)});

		//a.set(\p, pp);

		msg.postln();
		if(msg[1]==0,{gg1=0},{gg1 = (msg[1]-400)/(40-400)});
		if(msg[2]==0,{gg2=0},{gg2 = (msg[2]-400)/(40-400)});
		if(msg[3]==0,{gg3=0},{gg3 = (msg[3]-400)/(40-400)});
		if(msg[4]==0,{gg4=0},{gg4 = (msg[4]-400)/(40-400)});
		if(msg[5]==0,{gg5=0},{gg5 = (msg[5]-400)/(40-400)});


		a.set(\g1, gg1);
		a.set(\g2, gg2);
		a.set(\g3, gg3);
		a.set(\g4, gg4);
		a.set(\g5, gg5);

		'aaa'.postln();
		gg1.postln();
		gg2.postln();
		gg3.postln();
		gg4.postln();
		gg5.postln();

		/*var secondGrade=msg[1],
		thirdGrade=msg[2],
		fourthGrade=msg[3];


		secondGrade.post();
		' '.post();
		thirdGrade.post();
		' '.post();
		fourthGrade.postln();
		' '.postln();
		a.set(\sG,secondGrade);
		a.set(\tG,thirdGrade);
		a.set(\fG,fourthGrade);*/
	},
	"/chord");

)
