def formatted_bin(num):
    temp=bin(num)[2:].zfill(8)
    return temp

def turn_on(status_code, place):
    temp=status_code ^| place
    return temp
