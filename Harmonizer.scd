// Settings per cambiare input audio

Server.local.options.inDevice = "MME : Cuffie (Audio Bluetooth)";
Server.local.options.outDevice = " MME : Cuffie (Audio Bluetooth)";

// Player
(
 SynthDef(\harm,
	{

		// p1, p2, p3 sono gli argomenti per i pitch;
		// g1, g2, g3 sono gli argomenti per i gain
		arg p1 = 1.0, p2 = 1.0, p3 = 1.0, g1 = 1.0, g2 = 1.0, g3 = 1.0;

		var wS=0.1;

		// fai QUESTO se vuoi usare il file vocals (cambialo a seconda del tuo path assoluto
		var infile="C:/Users/miche/Documents/AirHarmonizer/vocals.wav";
		var b = Buffer.read(s, infile);
		var input=PlayBuf.ar(2,b.bufnum,BufRateScale.kr(b.bufnum),loop:1);

		// decommenta questo se vuoi invece l'input del microfono
		//var input=AudioIn.ar([1,2]);


		var o1=PitchShift.ar(input,windowSize:wS,pitchRatio:p1);
		var o2=PitchShift.ar(input,windowSize:wS,pitchRatio:p2);
		var o3=PitchShift.ar(input,windowSize:wS,pitchRatio:p3);

		var out_signal=input+(o1*g1)+(o2*g2)+(o3*g3);//o1+o2+o3;//
		Out.ar(1, out_signal);

 }).add;
)





// prova Senza OSC
(
a = Synth(\harm);
a.set(\p1, 0.5,\g1,1, \p2,1, \g2,0.5, \g3,0);
)


// prova OSC
NetAddr("127.0.0.1",57120);

(


var song, freq, loud,pan;

a = Synth(\harm);
a.set(\p1, 1,\p2,1, \p3,2);


OSCdef('OSCreceiver',
	{
		arg msg;
		var secondGrade=msg[1],
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
		a.set(\fG,fourthGrade);
	},
	"/chord");

)
