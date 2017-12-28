def formatted_bin(num):
    temp=bin(num)[2:].zfill(8)
    return temp

def turn_on_vector(status_code, place):
    temp=status_code
    temp|= 1 << place
    return temp

def test_vector(status_code, place):
    temp=(int(status_code) >> place) & 1
    return temp
