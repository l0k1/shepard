import sys

length_to_check = 30
length = 0
found = 0


gbrom = open('./shepard.gb','rb')

while True:
    x = gbrom.read(1)
    if x == '':
        break
    if x == b'\x00':
        found = found + 1
        if found > length_to_check:
            break
    else:
        if found > 0:
            length = length + found + 1
            found = 0
        else:
            length = length + 1
    # print(str(x) + '|' + hex(length))

gbrom.close()
print('ROM length: ' + hex(length))
