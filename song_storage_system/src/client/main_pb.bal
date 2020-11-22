import ballerina/grpc;

public type SongRecsBlockingClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function __init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR, getDescriptorMap());
    }

    public remote function readRec(recRequest req, grpc:Headers? headers = ()) returns ([readResponse, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("SongRecs/readRec", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<readResponse>result, resHeaders];
        
    }

    public remote function writeRec(recWriteCom req, grpc:Headers? headers = ()) returns ([writeRes, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("SongRecs/writeRec", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<writeRes>result, resHeaders];
        
    }

    public remote function updateRec(Updatereq req, grpc:Headers? headers = ()) returns ([upResponse, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("SongRecs/updateRec", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<upResponse>result, resHeaders];
        
    }

};

public type SongRecsClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function __init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR, getDescriptorMap());
    }

    public remote function readRec(recRequest req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("SongRecs/readRec", req, msgListener, headers);
    }

    public remote function writeRec(recWriteCom req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("SongRecs/writeRec", req, msgListener, headers);
    }

    public remote function updateRec(Updatereq req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("SongRecs/updateRec", req, msgListener, headers);
    }

};

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

