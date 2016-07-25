## OUTPUT VARIABLES

|    Name   | Class  | Description |
|-----------|--------|:-------------|
| *subjectID* | char   | ID entered by experimenter for participant |
| *result*    | struct | Primary output structure file (field definitions below            |
| *slideName* | cell   | Stimulus filednames in order of presentation            |

## result
- **blockSeeker** : stores block-wise runtime data
- **trialSeeker** : stores trial-wise runtime data
- **qdata** : [128x4 Array]
- **qim** : [128x2 Cell]
   
## result.blockSeeker
|   Column   |                      Description                       |
|------------|:-------------------------------------------------------|
| *Column 1* | block #                                                |
| *Column 2* | condition (1=WhyFace, 2=WhyHand, 3=HowFace, 4=HowHand) |
| *Column 3* | scheduled onset (s)                                    |
| *Column 4* | cue # (indices tp preblockcues/isicues fields)         |

## result.trialSeeker
|   Column   |                           Description                            |
|------------|:-----------------------------------------------------------------|
| *Column 1* | block #                                                          |
| *Column 2* | trial # (within-block)                                           |
| *Column 2* | condition (1=WhyFace, 2=WhyHand, 3=HowFace, 4=HowHand)           |
| *Column 4* | normative response (1=Yes, 2=No) [used to evaluate accuracy]     |
| *Column 5* | stimulus # (index to result.qim & result.qdata      |
| *Column 6* | (saved during runtime) trial onset (s) [relative to trigger ]                    |
| *Column 7* | (saved during runtime) response time to onset (s) [0 if No Resp] |
| *Column 8* | (saved during runtime) actual response [0 if No Resp]            |
| *Column 9* | (saved during runtime) trial offset [relative to trigger]                       |

## result.qdata
`qdata` is a numeric array. Each row contains data for a different image and corresponds to the rows in `qim`.

|   Column   |                           Description                            |
|------------|:------------------------------------------------------------------|
| *Column 1* | condition (1=WhyFace, 2=WhyHand, 3=HowFace, 4=HowHand)    |
| *Column 2* | normative response (1=Yes, 2=No)                               |
| *Column 2* | average valence rating (MTurk sample) [1(neg) to 9(pos)]          |
| *Column 4* | estimated image luminance (see `RGB2LUM` below)     |

## result.qim
`qim` is a cell array. Each row contains data for a different image used in the experiment. 

### RGB2LUM
Each color channel is weighted differently according to the CIE Color Space. CIE Luminance is computed assuming a modern monitor. For further detials, see Charles Pontyon's [Colour FAQ](http://www.poynton.com/notes/colour_and_gamma/ColorFAQ.html).

    cim = imread(im{i});
    if size(cim,3)==3
        lum(i) = mean2(.2125*cim(:,:,1) + .7154*cim(:,:,2) + .0721*cim(:,:,3)); % RGB
    else
        lum(i) = mean2(cim); % GRAYSCALE
    end

