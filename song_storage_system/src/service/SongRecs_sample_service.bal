import ballerina/grpc;
import ballerina/log;
import ballerina/io;

listener grpc:Listener ep = new (9090);
string filePath = "C:/Users/HP/Documents/GitHub/Assignment1/song_storage_system/src/files/recs.json";



function closeRc(io:ReadableCharacterChannel rc) {
    var result = rc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream",
                        err = result);
    }
}

function read(string path) returns @tainted json|error {

    io:ReadableByteChannel rbc = check io:openReadableFile(path);

    io:ReadableCharacterChannel rch = new (rbc, "UTF8");
    var result = rch.readJson();
    closeRc(rch);
    return result;
}

function closeWc(io:WritableCharacterChannel wc) {
    var result = wc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream",
                        err = result);
    }
}

function write(json content, string path) returns @tainted error? {

    io:WritableByteChannel wbc = check io:openWritableFile(path);

    io:WritableCharacterChannel wch = new (wbc, "UTF8");
    var result = wch.writeJson(content);
    closeWc(wch);
    return result;
}

service SongRecs on ep {

    resource function readRec(grpc:Caller caller, recRequest value)returns error? {
        // Implementation goes here.

        json js =<json>read(filePath);
        string payload = "";
        var a = js.toJsonString();
        string b = js.toString();
        map<json>detmap = <map<json>>js;
        io:println("Preparing to read the content written");

        var rResult = read(filePath);
        if (rResult is error) {
            log:printError("Error occurred while reading json: ",
                            err = rResult);
        } else {
            json j = rResult;
            if(detmap.hasKey(value.artistName)){
                var newJsn = typedesc<json>.constructFrom(detmap[value.artistName]);
                if (newJsn is error) {
                    io:println("Error occured");
                }
            }else if(detmap.hasKey(value.band)){
                var newJsn = typedesc<json>.constructFrom(detmap[value.band]);
                if (newJsn is error) {
                    io:println("Error occured");
                }
            }else if(detmap.hasKey(value.song)){
                var newJsn = typedesc<json>.constructFrom(detmap[value.song]);
                if (newJsn is error) {
                    io:println("Error occured");
                }
            }else if(detmap.hasKey(value.date)){
                var newJsn = typedesc<json>.constructFrom(detmap[value.date]);
                if (newJsn is error) {
                    io:println("Error occured");
                }
            }else if(detmap.hasKey(value.genre)){
                var newJsn = typedesc<json>.constructFrom(detmap[value.genre]);
                if (newJsn is error) {
                    io:println("Error occured");
                }
            }
            int|error i1 = <int>j.code;
            int i2 = <int> i1;
            json[] kk = <json[]>j.artist;

            artist[]|error ab = artist[].constructFrom(kk);
            artist[] abc = <artist[]>ab;

            json[] jj = <json[]>j.songs;
            song[]|error ss = song[].constructFrom(jj); 
            song[] sq = <song[]>ss;

            readResponse response = {code: i2,date: j.date.toString(),artists: abc,band: j.band.toString(), songs: sq};
            payload = response.toString();
        }

        check caller-> send(payload);
        check caller-> complete();

        // You should return a readResponse
    }
    resource function writeRec(grpc:Caller caller, recWriteCom value) returns error?{
        // Implementation goes here.
        int cde = value.code;
        string dt = value.date;
        json[]|error a = json[].constructFrom(value.artists);
        json[] ab = <json[]> a;
        string bnd = value.band;
        json[]|error s = json[].constructFrom(value.songs);
        json[] sn = <json[]>s;
        var rRes = read(filePath);
        json jh = <json>rRes;
        json j = {code: cde,date: dt,artists: ab, band: bnd, song: sn};
        string payload ="Writing complete";


        var wRes = write(j,filePath);
        if (wRes is error) {
            log:printError("There was an issue writing the record", wRes);
        }else{
            writeRes response = {respond: "Record Succesfully written"};
            
        }
        check caller -> send(payload);
        check caller -> complete();

        // You should return a writeRes
    }
    resource function updateRec(grpc:Caller caller, Updatereq value) {
        // Implementation goes here.
        json js =<json>read(filePath);
        

        // You should return a upResponse
    }
}

public type recRequest record {|
    string date = "";
    string artistName = "";
    string song = "";
    string band = "";
    string genre = "";
    
|};

public type recWriteCom record {|
    int code = 0;
    string date = "";
    artist[] artists = [];
    string band = "";
    song[] songs = [];
    
|};

public type writeRes record {|
    string respond = "";
    
|};

public type song record {|
    string title = "";
    string genre = "";
    string platform = "";
    
|};

public type artist record {|
    string name = "";
    string member = "";
    
|};

public type readResponse record {|
    int code = 0;
    string date = "";
    artist[] artists = [];
    string band = "";
    song[] songs = [];
    
|};

public type Updatereq record {|
    string recCode = "";
    string updateField = "";
    string newValue = "";
    
|};

public type upResponse record {|
    string upRes = "";
    
|};



const string ROOT_DESCRIPTOR = "0A0A6D61696E2E70726F746F227E0A0A7265635265717565737412120A0464617465180120012809520464617465121E0A0A6172746973744E616D65180220012809520A6172746973744E616D6512120A04736F6E671803200128095204736F6E6712120A0462616E64180420012809520462616E6412140A0567656E7265180520012809520567656E72652289010A0B7265635772697465436F6D12120A04636F64651801200128055204636F646512120A046461746518022001280952046461746512210A076172746973747318032003280B32072E61727469737452076172746973747312120A0462616E64180420012809520462616E64121B0A05736F6E677318052003280B32052E736F6E675205736F6E677322240A08777269746552657312180A07726573706F6E641801200128095207726573706F6E64224E0A04736F6E6712140A057469746C6518012001280952057469746C6512140A0567656E7265180220012809520567656E7265121A0A08706C6174666F726D1803200128095208706C6174666F726D22340A0661727469737412120A046E616D6518012001280952046E616D6512160A066D656D62657218022001280952066D656D626572228A010A0C72656164526573706F6E736512120A04636F64651801200128055204636F646512120A046461746518022001280952046461746512210A076172746973747318032003280B32072E61727469737452076172746973747312120A0462616E64180420012809520462616E64121B0A05736F6E677318052003280B32052E736F6E675205736F6E677322630A0955706461746572657112180A07726563436F64651801200128095207726563436F646512200A0B7570646174654669656C64180220012809520B7570646174654669656C64121A0A086E657756616C756518032001280952086E657756616C756522220A0A7570526573706F6E736512140A05757052657318012001280952057570526573327C0A08536F6E675265637312250A0772656164526563120B2E726563526571756573741A0D2E72656164526573706F6E736512230A087772697465526563120C2E7265635772697465436F6D1A092E777269746552657312240A09757064617465526563120A2E5570646174657265711A0B2E7570526573706F6E7365620670726F746F33";
function getDescriptorMap() returns map<string> {
    return {
        "main.proto":"0A0A6D61696E2E70726F746F227E0A0A7265635265717565737412120A0464617465180120012809520464617465121E0A0A6172746973744E616D65180220012809520A6172746973744E616D6512120A04736F6E671803200128095204736F6E6712120A0462616E64180420012809520462616E6412140A0567656E7265180520012809520567656E72652289010A0B7265635772697465436F6D12120A04636F64651801200128055204636F646512120A046461746518022001280952046461746512210A076172746973747318032003280B32072E61727469737452076172746973747312120A0462616E64180420012809520462616E64121B0A05736F6E677318052003280B32052E736F6E675205736F6E677322240A08777269746552657312180A07726573706F6E641801200128095207726573706F6E64224E0A04736F6E6712140A057469746C6518012001280952057469746C6512140A0567656E7265180220012809520567656E7265121A0A08706C6174666F726D1803200128095208706C6174666F726D22340A0661727469737412120A046E616D6518012001280952046E616D6512160A066D656D62657218022001280952066D656D626572228A010A0C72656164526573706F6E736512120A04636F64651801200128055204636F646512120A046461746518022001280952046461746512210A076172746973747318032003280B32072E61727469737452076172746973747312120A0462616E64180420012809520462616E64121B0A05736F6E677318052003280B32052E736F6E675205736F6E677322630A0955706461746572657112180A07726563436F64651801200128095207726563436F646512200A0B7570646174654669656C64180220012809520B7570646174654669656C64121A0A086E657756616C756518032001280952086E657756616C756522220A0A7570526573706F6E736512140A05757052657318012001280952057570526573327C0A08536F6E675265637312250A0772656164526563120B2E726563526571756573741A0D2E72656164526573706F6E736512230A087772697465526563120C2E7265635772697465436F6D1A092E777269746552657312240A09757064617465526563120A2E5570646174657265711A0B2E7570526573706F6E7365620670726F746F33"
        
    };
}

