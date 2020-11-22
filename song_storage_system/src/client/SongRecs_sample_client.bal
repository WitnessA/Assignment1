import ballerina/io;
import ballerina/grpc;
import ballerina/stringutils;
import ballerina/lang.'int;


public type artst record{
    string name = "";
    string member = "";
};
public type sOng record{
    string title = "";
    string genre = "";
    string platform ="";
};

public function main (string... args) {

    SongRecsBlockingClient blockingEp = new("http://localhost:9090");
    io:println("*********Welcome to the song management system*********");
    io:println("                  1. Add Record");
    io:println("                  2. Read Record");
    io:println("                  3. Update Record");
    io:println("Please enter the number next to the action");
    io:println("you Want to take...");
    string desc;
    desc = io:readln(": ");

    if (desc == "1") {

        io:println("________________Add a Record________________");
        string dte;
        string bnd;
        string ttle;
        string pltform;
        string gnre;
        any artnum;
        int cde;
        
        io:println("Enter Band Name: \n");
        bnd = io:readln(": ");
        io:println("Enter song Title: \n");
        ttle = io:readln(": ");
        io:println("Enter song Platform: \n");
        pltform = io:readln(": ");
        io:println("Enter song genre: \n");
        gnre = io:readln(": ");
        io:println("Date of entry: \n");
        dte = io:readln(": ");
        io:println("Enter number of artists involved: \n");
        artnum = io:readln(": ");

        string artStr = <string>artnum;
        int|error artInt = 'int:fromString(artStr);
        int c = <int>artInt;
        int i = 0;
        string nme;
        string mmber;

        artist[] ab = [];
        song[] sngs=[];
        while (i>c) {
        io:println("Enter artist name");
        nme=io:readln(": ");
        io:println("are they a band member? ");
        mmber = io:readln(": ");
        artist abc = {name: nme, member: mmber};
        ab.push(abc);
    }
        song sng = {title: ttle,platform: pltform, genre: gnre};
        cde = hashfunction(bnd,ttle);  
        sngs.push(sng);
        recWriteCom request = {code: cde, date: dte, artists: ab, band: bnd, songs: sngs};

        var reg1 = blockingEp->writeRec(request);
        if (reg1 is grpc:Error) {
            io:print("Got an Error: "+reg1.reason());
        }else{
            io:println("Server Response: \n", reg1);
        }
   
    }else if (desc =="2") {
        io:println("_________________Read Record_________________");
        string srch;
        io:println("Search using: ");
        io:println("1.Date: ");
        io:println("2.artistName: ");
        io:println("3.song: ");
        io:println("4.band: ");
        io:println("5.genre: ");
        io:println("Enter keyword: ");
        srch = io:readln(": ");

        //var reg2 = blockingEp->readRec()
        
    }else if (desc =="3") {
        
    }else{
        
    }



}

function hashfunction(string band, string title) returns int{
    string con = band.concat(title);
    int code = stringutils:hashCode(con);
    return code;
}


