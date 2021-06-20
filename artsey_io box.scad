use <roundedcube.scad>;
// https://danielupshaw.com/openscad-rounded-corners/

printCase = true;
printPlate = true;
cutCordHole = true;
printLid = true;
tapHoles = true;

columns = 4;
rows = 2;


//MX standard spacing is 19.05mm; use 22.05 with Adafruit NeoKey PCB Breakouts
mxSize = 22.05;
mxPlateThickness = 1.5;
mxHoleSize = 14;
mxHoleBezel = (mxSize - mxHoleSize) / 2;

keySpaceWide = columns * mxSize;
keySpaceTall = rows * mxSize;
keySpaceDeep = 45;
bezel = 15;
internalBezel = 5;
roundingLevel = 7.5;
bottomLipBezel = 8;

cordHoleRadius = 2.5;

lidThickness = 5;
innerLidThickness = 3;

tapHoleOuterWidth = 5.4;
tapHoleInnerWidth = 2.8;
tapHoleDepth = 6;

caseLidOffset = printLid ? 20 : 0;

bottomHoleWide = keySpaceWide + (2* (bezel - bottomLipBezel));
bottomHoleTall = keySpaceTall+ (2 * (bezel - bottomLipBezel));

pcbMargin = 10;
pcbBracketWidth = 36;

if(printCase) {
    translate([0,0,caseLidOffset]){
        difference(){
            roundedcube([(keySpaceWide + (2 * bezel)), (keySpaceTall + (2 * bezel)), keySpaceDeep], false, roundingLevel, "zmax");
            union(){
                translate([bezel, bezel, internalBezel])cube([keySpaceWide, keySpaceTall, (4*keySpaceDeep)]);
                translate([internalBezel, internalBezel, internalBezel])cube([keySpaceWide + (2* (bezel - internalBezel)), keySpaceTall+ (2 * (bezel - internalBezel)), (keySpaceDeep -(2* internalBezel))]);
                translate([bottomLipBezel, bottomLipBezel, 0 - internalBezel])cube([bottomHoleWide, bottomHoleTall, (keySpaceDeep -(2* bottomLipBezel))]);
            }
            
            if(cutCordHole){
                translate([(keySpaceWide + (2 * bezel))/2, keySpaceTall+bezel, (2*innerLidThickness)])rotate([90, 0, 0])cylinder(h = (2*bezel), r = (cordHoleRadius), center = true, $fn = 100);
                translate([(keySpaceWide + (2 * bezel))/2 - cordHoleRadius, keySpaceTall, (-1*innerLidThickness)])cube([(2*cordHoleRadius), (3*bezel), (3*innerLidThickness)]);
            }
            
            if(tapHoles) {
                translate([(bottomLipBezel+(0.5 * tapHoleOuterWidth))/2, (bottomLipBezel +(0.5 * tapHoleOuterWidth))/2, 0.5 * (tapHoleDepth)])cylinder(h = tapHoleDepth+1, d = tapHoleOuterWidth, center = true, $fn = 12);
                translate([(keySpaceWide + 2 * bezel -((bottomLipBezel+(0.5 * tapHoleOuterWidth))/2)), (bottomLipBezel +(0.5 * tapHoleOuterWidth))/2, 0.5 * (tapHoleDepth)])cylinder(h = tapHoleDepth+1, d = tapHoleOuterWidth, center = true, $fn = 12);
                translate([(bottomLipBezel+(0.5 * tapHoleOuterWidth))/2, (keySpaceTall + 2 * bezel - ((bottomLipBezel +(0.5 * tapHoleOuterWidth))/2)), 0.5 * (tapHoleDepth)])cylinder(h = tapHoleDepth+1, d = tapHoleOuterWidth, center = true, $fn = 12);
                translate([(keySpaceWide + 2 * bezel -((bottomLipBezel+(0.5 * tapHoleOuterWidth))/2)), (keySpaceTall + 2 * bezel - ((bottomLipBezel +(0.5 * tapHoleOuterWidth))/2)), 0.5 * (tapHoleDepth)])cylinder(h = tapHoleDepth+1, d = tapHoleOuterWidth, center = true, $fn = 12);
            }
        }
        if(printPlate) {
            translate([0.75*bezel, 0.75*bezel, keySpaceDeep - (internalBezel - 0.2)]){
                difference(){
                    cube([keySpaceWide + (0.5 * bezel), keySpaceTall + (0.5 * bezel), mxPlateThickness]);
                    translate([0.25 * bezel, 0.25 * bezel, -1 * mxPlateThickness]) {
                        for(y = [0 : rows]) {
                            for(x = [0 : columns]) {
                                translate([(x * mxSize) + mxHoleBezel, (y * mxSize) + mxHoleBezel, 0])cube([mxHoleSize, mxHoleSize, 3 * mxPlateThickness]);
                            }
                        }
                    }
                }
            }
        }
    }
}

if (printLid) {
    union(){
        difference(){
            roundedcube([(keySpaceWide + (2 * bezel)), (keySpaceTall + (2 * bezel)), lidThickness], false, roundingLevel, "z");
            translate([-1,-1,lidThickness])cube([(keySpaceWide + (2 * bezel)) + 2, (keySpaceTall + (2 * bezel)) + 2, 3*lidThickness]);
            translate([-1,-1,0 - 3 * lidThickness])cube([(keySpaceWide + (2 * bezel)) + 2, (keySpaceTall + (2 * bezel)) + 2, 3 * lidThickness]);
            
            if(tapHoles) {
                translate([(bottomLipBezel+(0.5 * tapHoleOuterWidth))/2, (bottomLipBezel +(0.5 * tapHoleOuterWidth))/2, 0.5 * (lidThickness - 1)]){
                    cylinder(h = lidThickness, d = tapHoleOuterWidth, center = true, $fn = 12);
                    cylinder(h = 2 * lidThickness, d = tapHoleInnerWidth, center = true, $fn = 80);
                }
                translate([(keySpaceWide + 2 * bezel -((bottomLipBezel+(0.5 * tapHoleOuterWidth))/2)), (bottomLipBezel +(0.5 * tapHoleOuterWidth))/2, 0.5 * (lidThickness - 1)]){
                    cylinder(h = lidThickness, d = tapHoleOuterWidth, center = true, $fn = 12);                cylinder(h = 2 * lidThickness, d = tapHoleInnerWidth, center = true, $fn = 80);
                }
                translate([(bottomLipBezel+(0.5 * tapHoleOuterWidth))/2, (keySpaceTall + 2 * bezel - ((bottomLipBezel +(0.5 * tapHoleOuterWidth))/2)), 0.5 * (lidThickness - 1)]){
                    cylinder(h = lidThickness, d = tapHoleOuterWidth, center = true, $fn = 12);                cylinder(h = 2 * lidThickness, d = tapHoleInnerWidth, center = true, $fn = 80);
                }
                translate([(keySpaceWide + 2 * bezel -((bottomLipBezel+(0.5 * tapHoleOuterWidth))/2)), (keySpaceTall + 2 * bezel - ((bottomLipBezel +(0.5 * tapHoleOuterWidth))/2)), 0.5 * (lidThickness - 1)]){
                    cylinder(h = lidThickness, d = tapHoleOuterWidth, center = true, $fn = 12);                cylinder(h = 2 * lidThickness, d = tapHoleInnerWidth, center = true, $fn = 80);
                }
                
            }
        }
        translate([1.1 * bottomLipBezel, 1.1 * bottomLipBezel, (0.9* lidThickness)]){
            difference(){
                cube([bottomHoleWide - (0.2 * bottomLipBezel), bottomHoleTall - (0.2 * bottomLipBezel), innerLidThickness +(0.1* lidThickness)]);
                translate([pcbMargin, bottomHoleTall / 2,0])cylinder(h = lidThickness*2, d = tapHoleOuterWidth, center = true, $fn = 12);
                translate([pcbMargin + pcbBracketWidth, bottomHoleTall / 2,0])cylinder(h = lidThickness*2, d = tapHoleOuterWidth, center = true, $fn = 12);
            }
        }
    }
}




echo("Maximum PCB size: ", keySpaceWide + (2* (bezel - internalBezel)), " by " , keySpaceTall+ (2 * (bezel - internalBezel)));
//echo("Minimum PCB Size: ", keySpaceWide, " by ", keySpaceTall);
echo("Final Dimensions: ", keySpaceWide + (2* bezel), "x", keySpaceTall + (2* bezel), "x", keySpaceDeep + lidThickness);




/*
MX spacing: 19.05
  4 wide: 76.2
  2 tall: 38.1



*/