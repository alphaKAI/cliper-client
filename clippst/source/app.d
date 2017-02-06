import std.process,
       std.base64,
       std.array,
       std.stdio,
       std.json,
       std.zlib;
import vibe.d;

string CLIPER_SERVER_ADDRESS,
       CLIPER_APIKEY;

struct Response {
  bool   flag;
  string payload;
}

Response fetch() {
  string resp;

  requestHTTP(CLIPER_SERVER_ADDRESS ~ "/api/v1/users",
              (scope req) {
                req.method = HTTPMethod.GET;
                req.headers["apikey"]       = CLIPER_APIKEY;
              },
              (scope res) {
                resp = res.bodyReader.readAllUTF8;
              });

  auto parsed = parseJSON(resp);
  long status = parsed.object["status"].integer;

  if (status == 0) {
    return Response(true, parsed.object["buffer"].str);
  } else {
    return Response(false, parsed.object["error"].str);
  }
}

void main() {
  CLIPER_SERVER_ADDRESS = environment.get("CLIPER_SERVER_ADDRESS");
  if (CLIPER_SERVER_ADDRESS is null) {
    throw new Error("Please set $CLIPER_SERVER_ADDRESS in environment variable.");
  }

  CLIPER_APIKEY = environment.get("CLIPER_APIKEY");
  if (CLIPER_APIKEY is null) {
    throw new Error("Please set $CLIPER_APIKEY in environment variable.");
  }

  Response res = fetch;

  if (res.flag) {
    ubyte[] xbuf = Base64.decode(res.payload);
    ubyte[] buf  = cast(ubyte[])uncompress(xbuf);
    write(cast(string)buf);
  } else {
    writeln("[ERROR] ", res.payload);
  }
}
