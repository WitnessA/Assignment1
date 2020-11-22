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
        recRequest req = {};
        if (srch == "1") {
            string srch2;
            io:println("Enter date: ");
            srch2 = io:readln(": ");
            req = {date: srch2};
        }else if(srch == "2"){
            string srch2;
            io:println("Enter Artist Name: ");
            srch2 = io:readln(": ");
            req = {date: srch2};
        }else if (srch == "3") {
            string srch2;
            io:println("Enter Song title: ");
            srch2 = io:readln(": ");
            req = {date: srch2};
        }else if(srch == "4"){
            string srch2;
            io:println("Enter Band Name: ");
            srch2 = io:readln(": ");
            req = {date: srch2};
        }else if (srch == "5") {
            string srch2;
            io:println("Enter Genre: ");
            srch2 = io:readln(": ");
            req = {date: srch2};
        }else{
            io:println("Invalid Field selection");
        }

        var reg2 = blockingEp->readRec(req);
        if(reg2 is grpc:Error){ 
        io:print("error"+reg2.reason());

    }else{
        io:println("Details from server: \n",reg2);
    }
    }else if (desc =="3") {
        io:println("__________________Update Record__________________");
        Updatereq req;
        string entry;
        string entry2;
        string entry3;
        io:println("Record to be updated: ");
        io:println("Enter record code");
        entry = io:readln(": ");
        io:println("Enter field to update");
        entry2 = io:readln(": ");
        io:println("Enter new Value");
        entry3 = io:readln(": ");

        req = {recCode: entry,updateField: entry2, newValue: entry3};
        
    }else{
        io:println("Invalid Selection");
    }



}

function hashfunction(string band, string title) returns int{
    string con = band.concat(title);
    int code = stringutils:hashCode(con);
    return code;
}


