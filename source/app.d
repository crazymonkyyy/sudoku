import raylib;
import basic;
alias digit=int;
enum gridsize=9;
digit[gridsize][gridsize] sudokugrid;
struct specdigit{
	bool[gridsize+2] data =true;
	alias data this;
}
enum boxsize=3;
enum boxes=gridsize/boxsize;
specdigit[gridsize][gridsize] specgrid;
digit[gridsize/boxsize][gridsize/boxsize] colorgrid;
const specdigit[gridsize][gridsize] defualtspecgrid;
struct digitinterface{
	int x; int y;
	ref digit get(){
		return sudokugrid[x-1][y-1];
	}
	alias get this;
	auto ref spec(){
		return specgrid[x-1][y-1];
	}
	auto ref color(){
		return colorgrid[(x-1)/boxsize][(y-1)/boxsize];
	}
}
struct grid_{
	auto ref opIndex(int x,int y){
		return digitinterface(x,y);
	}
}
enum grid=grid_();
bool verifygroup(int[gridsize] i){
	static foreach(j;1..gridsize+1){
		if(i[].count(j) >= 2){return false;}
	}
	return true;
}
bool verifycol(int i){
	int[gridsize] o;
	foreach(j;1..gridsize+1){
		o[j-1]=grid[j,i];
	}
	return o.verifygroup;
}
bool verifyrow(int i){
	int[gridsize] o;
	foreach(j;1..gridsize+1){
		o[j-1]=grid[i,j];
	}
	return o.verifygroup;
}
bool verifybox(int i, int j){
	int[gridsize] o;
	int k=0;
	foreach(ii;0..3){
	foreach(jj;0..3){
		o[k]=grid[i+ii,j+jj];
		k++;
	}}
	return o.verifygroup;
}
bool verifygrid(){
	foreach(i;1..gridsize+1){
		if( ! verifyrow(i)){ return false;}
	}
	foreach(i;1..gridsize+1){
		if( ! verifycol(i)){ return false;}
	}
	foreach(i;[1,4,7]){
	foreach(j;[1,4,7]){
		if( ! verifybox(i,j)){return false;}
	}}
	return true;
}
void specgroup(digitinterface[gridsize] group){
	foreach(e;group){
		if(e!=0){
			foreach(f;group){
				f.spec[e]=false;
}}}}
void speccol(int i){
	digitinterface[gridsize] o;
	foreach(j;1..gridsize+1){
		o[j-1]=grid[j,i];
	}
	o.specgroup;
}
void specrow(int i){
	digitinterface[gridsize] o;
	foreach(j;1..gridsize+1){
		o[j-1]=grid[i,j];
	}
	o.specgroup;
}
void specbox(int i, int j){
	digitinterface[gridsize] o;
	int k=0;
	foreach(ii;0..3){
	foreach(jj;0..3){
		o[k]=grid[i+ii,j+jj];
		k++;
	}}
	o.specgroup;
}
void specgrid_(){
	specgrid=defualtspecgrid;
	foreach(i;1..gridsize+1){
		specrow(i);
	}
	foreach(i;1..gridsize+1){
		speccol(i);
	}
	foreach(i;[1,4,7]){
	foreach(j;[1,4,7]){
		specbox(i,j);
	}}
}
bool gridfinished(){
	foreach(i;1..gridsize+1){
	foreach(j;1..gridsize+1){
		if(grid[i,j]==0){return false;}
	}}
	return true;
}
void fillgrid(){
	void fillrestofgrid(int cell){
		int[gridsize] a=[1,2,3,4,5,6,7,8,9].randomShuffle;
		foreach(e;a){
			if(gridfinished && verifygrid){goto exit;}
			grid[(cell/gridsize)+1,(cell%gridsize)+1]=e;
			if(verifygrid){fillrestofgrid(cell+1);}
		}
		if( ! verifygrid){grid[(cell/gridsize)+1,(cell%gridsize)+1]=0;}
		exit:
	}
	fillrestofgrid(0);
}
void removedigit(){
	grid[uniform(1,10),uniform(1,10)]=0;
}
enum windowsize=600;
enum numoffset=-54;
void drawnumbers(){
	foreach(i;1..gridsize+1){
	foreach(j;1..gridsize+1){
		if( ! grid[i,j]==0){
			DrawText(int(grid[i,j]).to!string.toStringz, i*(windowsize/9)+numoffset, j*(windowsize/9)+numoffset, 48, BLACK);
	}}}
}
void drawgrid(){
	foreach(i;0..gridsize+1){
		auto v1=Vector2(i*(windowsize/9),0);
		auto v2=Vector2(i*(windowsize/9),windowsize);
		int thick=(i%3==0) ? 6:2;
		DrawLineEx(v1,v2,thick,BLACK);
	}
	foreach(i;0..gridsize+1){
		auto v1=Vector2(0         ,i*(windowsize/9));
		auto v2=Vector2(windowsize,i*(windowsize/9));
		int thick=(i%3==0) ? 6:1;
		DrawLineEx(v1,v2,thick,BLACK);
	}
}
enum Color[] colors=[RAYWHITE,RED,YELLOW,GREEN,BLUE,GRAY,BLACK];
//void drawcolor(){//unbelievably dubouis
//	foreach(i;iota(0,boxes-1)){
//	foreach(j;iota(0,boxes-1)){
//		auto v1=Vector2(i    *(windowsize/boxes),j    *(windowsize/boxes));
//		auto v2=Vector2(i*(windowsize/boxes)+10,j*(windowsize/boxes)+10);
//		DrawRectangleV(v1,v2,colors[grid[i*3+1,j*3+1].color]);
//	}}
//}
void drawcolor(){//unbelievably dubouis
	foreach(i;0..3){
	foreach(j;0..3){
		auto v1=Vector2(i    *(windowsize/boxes),j    *(windowsize/boxes));
		auto v2=Vector2((i+1)*(windowsize/boxes),(j+1)*(windowsize/boxes));
		DrawRectangleV(v1,v2,colors[colorgrid[i][j]]);
	}}
}
void main(){
	InitWindow(windowsize,windowsize, "Hello, Raylib-D!");
	SetWindowPosition(2000,0);
	SetTargetFPS(60);
	fillgrid;
	removedigit;
	grid[1,1].color=1;
	grid[1,4].color=2;
	grid[1,7].color=3;
	grid[4,1].color=4;
	grid[4,4].color=1;
	grid[4,7].color=2;
	grid[7,1].color=3;
	grid[7,4].color=4;
	grid[7,7].color=1;
	foreach(i;0..20){removedigit;}
	while (!WindowShouldClose()){
		//grid[uniform(1,10),uniform(1,10)]=uniform(1,10);
		BeginDrawing();
			if(IsMouseButtonReleased(0)){
				grid[(GetMouseX*gridsize)/windowsize+1,(GetMouseY*gridsize)/windowsize+1] =
				"zenity --entry".exe.to!int;
			}
			if(IsMouseButtonReleased(1)){
				grid[(GetMouseX*gridsize)/windowsize+1,(GetMouseY*gridsize)/windowsize+1].color =
				"zenity --entry".exe.to!int;
			}
			ClearBackground(RAYWHITE);
			//DrawText("Hello, World!", 400, 300, 28, BLACK);
			//DrawFPS(10,10);
			drawcolor;
			drawnumbers;
			drawgrid;
			specgrid_;
			//grid[9,9].spec.writeln;
			if( ! verifygrid){verifygrid.writeln;}
		EndDrawing();
	}
	CloseWindow();
}