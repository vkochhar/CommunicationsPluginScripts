function [output] = Matlab_TransmitterModel_freqHop(input)
% NOTE: the outputs that are returned
%       MUST be in the same order as registered
%
% Use with receivers which are frequency auto-tracking in order for
% the receiver to "automatically" hop in unison with the transmitter.
% If a receiver is not frequency auto-tracking, you will need to have
% a receiver plugin script too and put a global declaration for the
% freqSeq at the top of the receiver plugin file then you will use
% the same freqSeq in both scripts.  For example, when using with a
% CommSystem where there will be interference transmitters, you will want
% to have the hopping sequence specified in a receiver script too, so 
% the receiver doesn't "re-tune" to the interferer's frequency.
%
% Note: In STK 8.x, this will retain it's freqIndex count from report
% run to report run.  You can force it to start over at freqIndex=1 by
% simply closing and reopening the Transmitter's property page, or by
% reselecting the plug-in file. As an alternative to using an index
% variable, you can use the EpochSec input definition instead.  It is
% left as a user excersize to declare the EpochSec input variable and
% use the EpochSec input value to index into the freqSeq array :)  In 
% STK 9.x, this accumulation of the freqIndex value should not exist.
%
% This example shows static output parameters, but these parameters
% may change value at each time step.
%
% freqs - array of frequency values 
% freqSeq - order in which the values in freqs should be used
%
% You can specify your freqs to be in increasing frequency order and use the 
% freqSeq to easily rearrange the frequencies to produce a different 
% hopping sequence.  
% Or, if you specify your freqs in the desired hopping order, and set the
% freqSeq to 1 thru n in increasing order.

% Author: cmoyer dot work at gmail dot com
% Version: 1.0
% Date Modified: 6/05/2009


global freqIndex;

switch input.method
    
    case 'register'
        freqIndex = 1;

 	% register output variables       
        Frequency= {'ArgumentName','Frequency',...
                     'Name','Frequency',...
                     'ArgumentType','Output'};

        Power= {'ArgumentName','Power',...
                     'Name','Power',...
                     'ArgumentType','Output'};
 
        Gain= {'ArgumentName','Gain',...
                     'Name','Gain',...
                     'ArgumentType','Output'};

        DataRate= {'ArgumentName','DataRate',...
                    'Name','DataRate',...
                    'ArgumentType','Output'};

       Bandwidth= {'ArgumentName','Bandwidth',...
                    'Name','Bandwidth',...
                    'ArgumentType','Output'};
 
        Modulation= {'ArgumentName','Modulation',...
                     'Name','Modulation',...
                     'ArgumentType','Output'};
   
        PostTransmitLoss= {'ArgumentName','PostTransmitLoss',...
                    'Name','PostTransmitLoss',...
                    'ArgumentType','Output'};
    
        PolType= {'ArgumentName','PolType',...
                    'Name','PolType',...
                    'ArgumentType','Output'};

        PolRefAxis= {'ArgumentName','PolRefAxis',...
                     'Name','PolRefAxis',...
                     'ArgumentType','Output'};
    
        PolTiltAngle= {'ArgumentName','PolTiltAngle',...
                    'Name','PolTiltAngle',...
                    'ArgumentType','Output'};

        PolAxialRatio= {'ArgumentName','PolAxialRatio',...
                     'Name','PolAxialRatio',...
                     'ArgumentType','Output'};
    
        UseCDMASpreadGain= {'ArgumentName','UseCDMASpreadGain',...
                    'Name','UseCDMASpreadGain',...
                    'ArgumentType','Output'};
    
        CDMAGain= {'ArgumentName','CDMAGain',...
                    'Name','CDMAGain',...
                    'ArgumentType','Output'};

 	% register input variables       
   
        date = {'ArgumentName','DateUTC',...
                'Name','DateUTC',...
                'ArgumentType','Input'};
 
        CbName = {'ArgumentName','CbName',...
                  'Name','CbName',...
                  'ArgumentType','Input'};

        XmtrPosCBF = {'ArgumentName','XmtrPosCBF',...
               'Name','XmtrPosCBF',...
               'ArgumentType','Input'};

        XmtrAttitude= {'ArgumentName','XmtrAttitude',...
               'Name','XmtrAttitude',...
               'ArgumentType','Input'};

        RcvrPosCBF= {'ArgumentName','RcvrPosCBF',...
               'Name','RcvrPosCBF',...
               'ArgumentType','Input'};
 
        RcvrAttitude= {'ArgumentName','RcvrAttitude',...
               'Name','RcvrAttitude',...
               'ArgumentType','Input'};
   
        output = {Frequency, Power, Gain, DataRate, Bandwidth,...
                  Modulation, PostTransmitLoss,...
                  PolType, PolRefAxis, PolTiltAngle, PolAxialRatio,...
                  UseCDMASpreadGain, CDMAGain,...
                  date, CbName, XmtrPosCBF, XmtrAttitude, RcvrPosCBF, RcvrAttitude};


    case 'compute'
    
        computeData = input.methodData;

	% compute the Test Model : 
	% Example Model for testing only
	% Transmitter input & outpur parameter usage is shown
	% 

	% USER Transmitter MODEL AREA.
        
	  xmtrPos = [ 0 0 0 ];
	  rcvrPos = [ 0 0 0 ];
        xmAttQuat = [ 0 0 0 0 ];
        rcAttQuat = [ 0 0 0 0 ];
	  xmtrPos = computeData.XmtrPosCBF;
	  rcvrPos = computeData.RcvrPosCBF;
        xmAttQuat = computeData.XmtrAttitude;
        rcAttQuat = computeData.RcvrAttitude;

      freqs = [1805.100e6 1805.305e6 1805.510e6 1805.715e6 1805.920e6 1806.125e6 1806.330e6 1806.535e6 1806.740e6 1806.945e6];
	freqSeq = [ 1 3 5 7 9 2 4 6 8 10 ];
      %freqSeq = [1805.100e6 1806.125e6 1805.305e6 1806.330e6 1805.510e6 1806.535e6 1805.715e6 1806.740e6 1805.920e6 1806.945e6];
	
      if (freqIndex > size(freqSeq,2))
          freqIndex = 1;
      end
      
      freq = freqs(freqSeq(freqIndex));
      freqIndex = freqIndex+1;

        output.Frequency= freq;
        output.Power= 35;
        output.Gain= 30;
        output.DataRate= 12.0e6;
        output.Bandwidth= 200.0e3;
        output.Modulation= 'BPSK';
        output.PostTransmitLoss= -2.3;
        output.PolType= 0;
        output.PolRefAxis= 0;
        output.PolTiltAngle= 0.0;
        output.PolAxialRatio= 1.0;
        output.UseCDMASpreadGain= 0;
        output.CDMAGain= 0.0;

	% END OF USER MODEL AREA

    otherwise
        output = [];
end

