# Echo server program
# simple listening server for remote execution
# Un-encrypted, no authentication, insecure unles used in a controlled environment
import os
import socket

HOST = ''                 # Symbolic name meaning all available interfaces
PORT = 60000              # Arbitrary non-privileged port
while 1:
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind((HOST, PORT))
    while 1:
        s.listen(1)
        conn, addr = s.accept()
        data = conn.recv(1024)
        if str(data,"utf-8")=="exit":
            exit()
        print(str(data,"utf-8"))
        reply=os.popen(str(data,"utf-8"))
        reply=bytes(reply.read(),"utf-8")
        conn.send(reply)
        if not data: break
        conn.close()