/*********************************************
 * OPL 12.2 Model
 * Author: creeves
 * Creation Date: 29/03/2017 at 4:22:22 PM
 *********************************************/
 //using CP; //not as good as MIP in short solution time, not tested for longer
 
 
/********************************************
* Input
**********************************************/

int Fx = ...;
int Fy = ...;
int M = ...;
float eps = 0.001;

{string} Equipment = ...;

{int} Lengths = ...;

int Width = ...;

//{int} Pieces = ...;
{int} Pieces = asSet(1..56);
//{int} P100 = asSet(1..16);
//{int} P75 = asSet(17..32);
//{int} P60 = asSet(33..48);
//{int} P50 = asSet(49..56);

int P_Lengths[Pieces] = ...;

int Needed[Equipment][Lengths] = ...;

int UpperBound[Equipment] = ...;
/*


{int} Qtips = ...;
{int} Longs = ...;
{int} Staffs = ...;
{int} Shorts = ...;

float QtipValue[Qtips] = ...;
float LongValue[Longs] = ...;
float StaffValue[Staffs] = ...;
float ShortValue[Shorts] = ...;
*/

{int} Order = asSet(1..8);
float Value[Equipment][Order] = ...;//[[1,1,0.5,0.25,0.1,0.1,0,0],[1,1,0.5,0.5,0.2,0.1,0,0],[1,1,0.5,0.5,0.2,0.1,0,0],[1,1,0.75, 0.75,0.5,0.5,0.25,0.25]];


// warm start input
int warmcut[Pieces] = [1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0];
int warmcomplete[Equipment][Order] = [[1,1,0,0,0,0,0,0],[1,1,0,0,0,0,0,0],[1,1,0,0,0,0,0,0],[1,1,0,0,0,0,0,0]];
int warmassign[Lengths][Equipment] = [[0,0,8,0],[4,0,0,0],[4,0,0,4],[0,4,0,0]];
/********************************************
* Decision variables
**********************************************/

dvar int x[Pieces] in 0..200; // this handles a couple of boundary constraints
dvar int y[Pieces] in 0..100; // this  handles a couple of boundary constraints
dvar int rotation[Pieces] in 0..1;
dvar int cut[Pieces] in 0..1; // was this piece actually cut?

dvar int assigned[Lengths][Equipment] in 0..16;
dvar int completed[Equipment][Order] in 0..1;

dvar int X_overlap[Pieces][Pieces] in 0..1;
//dvar int Y_overlap[Pieces][Pieces] in 0..1;
dvar int totheright[Pieces][Pieces] in 0..1;
dvar int isbelow[Pieces][Pieces] in 0..1;

dvar float xmax in 0..Fx;
dvar float ymax in 0..Fy;

//dvar int cutAndRotated[Pieces] in 0..1;
//dvar int cutAndNotRotated[Pieces] in 0..1;
//dvar float eta;
/********************************************
* Objective Function
**********************************************/

maximize //100 * eta + sum(p in Pieces) cut[p]

sum(e in Equipment, o in Order) completed[e][o]*Value[e][o]
// plus assign some value to useful left over pieces
+ eps*(sum(p in Pieces)cut[p]*P_Lengths[p] - sum(l in Lengths, e in Equipment)assigned[l][e]*l)
- (xmax/6336+ ymax/2880)/10
//- (xmax/Fx + ymax/Fy)/10
;

/*********************************************
* Constraints
**********************************************/

subject to {

//forall(p in Pieces){  
//cutAndRotated[p] <= cut[p]; 
//cutAndRotated[p] <= rotation[p];  
//cutAndNotRotated[p] <= cut[p];
//cutAndNotRotated[p] <= (1 - rotation[p]);
//}
//
//eta <= sum(p in Pieces) cutAndRotated[p];
//eta <= sum(p in Pieces) cutAndNotRotated[p];
  
//  ctbs1: cut[33] == 1;
//  ctbs2: cut[34] == 1;
//  ctbs3: x[33] == 0;
//    ctbs4: x[34] == 3;
  
 cttightenx: xmax >= sum(p in Pieces) x[p];
  cttighteny: ymax >= sum(p in Pieces)y[p];
  //forall(p in Pieces)xmax>= x[p];//+ P_Lengths[p]*(1-rotation[p])+ Width*rotation[p] ;
//  forall(p in Pieces)ymax>= y[p];//+ P_Lengths[p]*rotation[p]+ Width*(1-rotation[p]);
  
  
ct_complete_each: forall(e in Equipment,p in Lengths)assigned[p][e] >=Needed[e][p]*sum(o in Order)completed[e][o];
 
ct_assign_cut_pieces_only_once: forall(p1 in Lengths)sum(e in Equipment) assigned[p1][e] <=sum(p2 in Pieces: P_Lengths[p2] ==p1)cut[p2];
  
  ct_assign_in_blockX: forall(p in Pieces) Fx-x[p] - P_Lengths[p]*(1-rotation[p]) - Width*rotation[p] >= 0;
ct_assign_in_blockY: forall(p in Pieces) Fy-y[p] - Width*(1-rotation[p]) - P_Lengths[p]*rotation[p] >= 0;

ct_totheright:forall(p in Pieces, q in Pieces: q!=p)M*totheright[p][q] >= x[q] - x[p];
ct_below:forall(p in Pieces, q in Pieces: q!=p)M*isbelow[p][q] >= y[q] - y[p];
ct_totheright2:forall(p in Pieces, q in Pieces: q>p)M*totheright[p][q] >= x[q] - x[p]+1;
ct_below2:forall(p in Pieces, q in Pieces: q>p)M*isbelow[p][q] >= y[q] - y[p]+1;

//mode 1
//ct_overlapX: forall(p in Pieces, q in Pieces: q!=p)M*(X_overlap[p][q] +1 - cut[p]+1-cut[q] +1-totheright[p][q])  >=x[p]-x[q]+P_Lengths[p]*(1-rotation[p]) + Width*rotation[p];
//ct_overlapY: forall(p in Pieces, q in Pieces: q!=p)M*(Y_overlap[p][q] + 1 - cut[p]+1-cut[q]+1-isbelow[p][q]) >=y[p]-y[q]+Width*(1-rotation[p]) +P_Lengths[p]*rotation[p];

//ct_overlapXY1: forall(p in Pieces, q in Pieces: q!=p)Y_overlap[p][q] +X_overlap[q][p] <= 1; // can only overlap in one dimension
//ct_overlapXY2: forall(p in Pieces, q in Pieces: q!=p)Y_overlap[p][q] +X_overlap[p][q] <= 1; // can only overlap in one dimension


// mode 2
ct_overlapX: forall(p in Pieces, q in Pieces: q!=p)M*(X_overlap[p][q] +1 - cut[p]+1-cut[q] +1-totheright[p][q])  >=x[p]+P_Lengths[p]*(1-rotation[p]) + Width*rotation[p]-x[q];
ct_overlapY1: forall(p in Pieces, q in Pieces: q!=p)M*(1-X_overlap[p][q] + 1 - cut[p]+1-cut[q]+1-isbelow[p][q]) >=y[p]-y[q]+Width*(1-rotation[p]) +P_Lengths[p]*rotation[p];
ct_overlapY2: forall(p in Pieces, q in Pieces: q!=p)M*(1-X_overlap[p][q] + 1 - cut[p]+1-cut[q]+1-isbelow[q][p]) >=y[q]-y[p]+Width*(1-rotation[q]) +P_Lengths[q]*rotation[q];

ct_order_of_cut: forall(l in Lengths, p1 in Pieces: P_Lengths[p1]==l, p2 in Pieces: P_Lengths[p2]==l && p2 > p1) cut[p1] >= cut[p2];

 ct_upperlimit: forall(e in Equipment) sum(o in Order)completed[e][o] <= UpperBound[e]; // unnecessary but possibly helpful?
  
  ct_order_of_supply: forall (e in Equipment, o1 in Order, o2 in Order: o2>o1) completed[e][o1] >= completed[e][o2]; // unnecessary (diminishing values) but possibly helpful for symmetry?
  
//  ct_order_of_position: // actively not helful, what about my other symmetry constriants then? larger index of same type always either to the right or below? doesn't hurt but not sure it actually helps much
//forall(l in Lengths, p1 in Pieces: P_Lengths[p1]==l, p2 in Pieces: P_Lengths[p2]==l && p2 > p1) totheright[p1][p2] >= totheright[p2][p1];
//forall(l in Lengths, p1 in Pieces: P_Lengths[p1]==l, p2 in Pieces: P_Lengths[p2]==l && p2 > p1) isbelow[p1][p2]+(x[p2]-x[p1]) >= isbelow[p2][p1];
//  
//  ct_minreq: sum(e in Equipment, o in Order) completed[e][o] >= 8; // minimum order, could make it slow to find initial solutions though, as with the ones below.
//  
//ct_extra: forall (e in Equipment) completed[e][2] ==1; // make at least two of each
//ct_8by100cm: forall (p in Pieces: p <= 8) cut[p] == 1;
//ct_4by75: forall (p in Pieces: p > 17 && p <=21) cut[p] == 1;
//ct_8by60: forall (p in Pieces: p > 32 && p <=40) cut[p] == 1;
//ct_4by50: forall (p in Pieces: p > 48 && p <=52) cut[p] == 1;

//ct_not_cut: forall(p in Pieces) M*cut[p] >= x[p];
//ct_not_cut2: forall(p in Pieces)M*cut[p]>= y[p];
}  

/*********************************************
* Post Processing
**********************************************/
tuple Easy_tuple {
int pieceID;
int xpos;
int ypos;
int rot;
}  
	{Easy_tuple} Easy_output = {<p,x[p],y[p],rotation[p]> | p in Pieces};
	
	tuple Useful_tuple {
int pieceID;
int x1;
int y1;
int x2;
int y2;
}

{Useful_tuple} Useful_output = {<p,x[p],y[p],x[p]+P_Lengths[p]*(1-rotation[p]) + Width*rotation[p],y[p]+P_Lengths[p]*rotation[p] + Width*(1-rotation[p])> | p in Pieces: cut[p] > 0};// x[p]+P_Lengths[p]*(1-rotation[p]) + Width*rotation[p] <= 200 && y[p]+P_Lengths[p]*rotation[p] + Width*(1-rotation[p]) <= 100};

execute{
 // writeln(Easy_output);
  writeln(Useful_output)
  //writeln(Easy_output2);
}  

main{
  thisOplModel.generate();  
  
  var def = thisOplModel.modelDefinition;   
  // Default behaviour
 // writeln("Default Behaviour");
  //var opl1 = new IloOplModel(def, cplex);
    var data = new IloOplDataSource("FoamCutting.dat"); // main .dat file
//opl1.addDataSource(data);  	
  //opl1.generate();
  //cplex.solve();   
  //writeln(opl1.printSolution());
  // Setting initial solution
  writeln("Setting initial solution");
  var opl2 = new IloOplModel(def, cplex);
opl2.addDataSource(data);  	
  opl2.generate();
  var vectors = new IloOplCplexVectors();
  // We attach the values (defined as data) as starting solution
  // for the variables x.
   vectors.attach(opl2.cut,opl2.warmcut);
    vectors.attach(opl2.assigned,opl2.warmassign);
    vectors.attach(opl2.completed,opl2.warmcomplete);
  
  vectors.setVectors(cplex);   
  cplex.solve();   
  writeln(opl2.printSolution());

 // opl1.end();
  opl2.end();
  
}
