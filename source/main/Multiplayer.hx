package main;

#if sys
import sys.net.UdpSocket;
import sys.net.Host;
import sys.net.Address;
import haxe.io.Bytes;

class UdpClient {
    private var socket:UdpSocket;
    private var port:Int;
    private var host:Host;
    
    public function new(hostStr:String, port:Int, localPort:Int) {
        this.host = new Host(hostStr); // Convertir el string a objeto de red
        this.socket = new UdpSocket();
        this.port = port;
        try {
            this.socket.bind(new Host("0.0.0.0"), localPort);
        } catch (e:Dynamic) {
            trace("No se pudo enlazar al puerto local " + localPort + ", usando puerto efímero. Detalle: " + e);
            this.socket.bind(new Host("0.0.0.0"), 0);
        }
        this.socket.setBroadcast(false);
        this.socket.setBlocking(false);
    }

    public function send(data:String):Void {
        var bytes = Bytes.ofString(data);
        var addr = new Address();
        addr.host = this.host.ip;
        addr.port = this.port;
        try {
            this.socket.sendTo(bytes, 0, bytes.length, addr);
        } catch (e:Dynamic) {
            trace("Error al enviar UDP: " + e);
        }
    }

    public function receive():String {
        var buffer = Bytes.alloc(4096);
        var senderAddress = new Address();
        try {
            var bytesRead = this.socket.readFrom(buffer, 0, buffer.length, senderAddress);
            if (bytesRead > 0) {
                return buffer.sub(0, bytesRead).toString();
            }
        } catch (e:haxe.io.Error) {
            // En modo no-bloqueante, si no hay datos, lanza haxe.io.Error.Blocked
        } catch (e:Dynamic) {
            trace("Error al recibir UDP: " + e);
        }
        return null;
    }

    public function close():Void {
        this.socket.close();
    }

    public static function getClientAddress():Null<{host:String, port:Int, localPort:Int}> {
        #if sys
        var args = Sys.args();
        for (i in 0...args.length) {
            if (args[i] == "-client" && i + 1 < args.length) {
                var addrStr = args[i + 1];
                var parts = addrStr.split(":");
                if (parts.length == 2) {
                    var host = parts[0];
                    var port = Std.parseInt(parts[1]);
                    if (port != null) {
                        return {host: host, port: port, localPort: port};
                    }
                } else if (parts.length == 3) {
                    var host = parts[0];
                    var port = Std.parseInt(parts[1]);
                    var localPort = Std.parseInt(parts[2]);
                    if (port != null && localPort != null) {
                        return {host: host, port: port, localPort: localPort};
                    }
                }
            }
        }
        #end
        return null;
    }
}
#else
class UdpClient {
    public function new(hostStr:String, port:Int, localPort:Int) {}
    public function send(data:String):Void {}
    public function receive():String { return null; }
    public function close():Void {}
    public static function getClientAddress():Null<{host:String, port:Int, localPort:Int}> { return null; }
}
#end