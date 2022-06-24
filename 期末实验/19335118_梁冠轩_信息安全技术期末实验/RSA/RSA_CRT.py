import time

def fastPower(base, power, MOD):
    result = 1
    while power > 0:
        if power % 2 == 1:
            result = (result * base) % MOD
        power = power // 2
        base = (base * base) % MOD
    return result

def gcd(a, b):
    while a != 0:
        a, b = b % a, a
    return b

def modulaInverse(b, m):
    if gcd(m, b) != 1:
        return None
    A1, A2, A3 = 1, 0, m
    B1, B2, B3 = 0, 1, b
    while True:
        Q = A3 // B3
        B1, B2, B3, A1, A2, A3 = (A1 - Q * B1), (A2 - Q * B2), (A3 - Q * B3), B1, B2, B3
        if B3 == 0:
            return None
        elif B3 == 1:
            break
    return B2 % m

#开始时间
start_time = time.time()

#1024位的明文
M = 0x0000190510a41630679425c803846ebf88239c321688a8c37de2fbaf1312362b3a95952e9f7373be7224275204552759738718c888310218850f01b2a56ff0b604e4f79eb7376464d4207a06494b917e05f2aaa90a98226c1f1e83870160d74aa1ec92e3939fa0e39aaeb694e81d749f39317f5b7f2a65142246647c0667359ea7a72a021a122e780375a4c308dd794ef407eaeee963be10417e11c54408dcfbaf765ed0af344956240284eddc3b03f94d4addf34a0defec143e27505f77f3557d1e6cfc45af527202e9ec42571eab2f0aefb17ba0cb599416fd4d8a6599b2c38e51b4dc3695414d5f6eb00eb0a5463dc1e07cbded15b80eedba9c8d6509f886
#选择两个1024位的素数作为p和q
p = 35074598033741402870122440591152763776959747722825812262017609833876282032036234158131883762850216623997088950455302388093413922032430390440287678109018554632705408465603405501793189560829238040729904915217738571965964480443844413087453480026823896871082770141101180959787910269023763457366484033978750683307
q = 177868678153255329271515065918260540535007072753615173407369983397392818131430406897774874316279597828143679930058356192676963809284221331947388679726934977037567471293722183902870023050766742639135006388159827656702014449889731655926768621644334320354221155537925493671542876775525110735235963228602004248263
n = p * q   #计算n
phi_n = (p - 1) * (q - 1)   #计算n的欧拉函数phi_n
e = 65537    #随机选择一个素数e
d = modulaInverse(e, phi_n)    #计算e对于phi_n的模反元素d
C = fastPower(M, e, n)     #将e和n作为公钥加密，得到密文
#利用中国剩余定理
dp = d % (p - 1)
dq = d % (q - 1)
qlnv = modulaInverse(q, p)  
#将p，q，d，dp，dq，qinv作为私钥进行解密，得到明文
Cp = C % p
Cq = C % q
M1 = fastPower(Cp, dp, p) 
M2 = fastPower(Cq, dq, q) 
h = (qlnv * ((M1 - M2) % p)) % p
M_ = M2 + h * q

#结束时间
end_time = time.time()

print("明文：", M)
print("RSA_CRT解密：", M_)
print("RSA_CRT运行时间：", end_time - start_time)