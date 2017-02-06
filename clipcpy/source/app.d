import std.process,
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

Response send(ubyte[] buf) {
  string resp;

  requestHTTP(CLIPER_SERVER_ADDRESS ~ "/api/v1/buffers",
              (scope req) {
                req.method = HTTPMethod.POST;
                req.headers["Content-Type"] = "application/octet-stream";
                req.headers["apikey"]       = CLIPER_APIKEY;
                req.writeBody(buf);
              },
              (scope res) {
                resp = res.bodyReader.readAllUTF8;
              });

  auto parsed = parseJSON(resp);
  long status = parsed.object["status"].integer;

  if (status == 0) {
    return Response(true);
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

  ubyte[] buf;

  foreach (ubyte[] buffer; stdin.byChunk(4096)) {
    buf ~= buffer;
  }

  if (!buf.empty) {
    ubyte[] xbuf = compress(buf);
    auto ret = send(xbuf);

    if (!ret.flag) {
      writeln("[ERROR] ", ret.payload);
    }
  }
}
