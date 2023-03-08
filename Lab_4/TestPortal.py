import PortalConnection
from pprint import pprint
import json

def setup(c):
  with c.conn.cursor() as cur:
      cur.execute(open("./master_setup.sql", "r").read())
      # cur.execute(open("../Lab_3/setup.sql", "r").read())
      # cur.execute(open("../Lab_3/triggers.sql", "r").read())

def pause():
  input("Press Enter to continue...")
  print("")

def pprint_info(data):
    info = json.loads(data)
    pprint({"Student": info.get("student")})
    pprint({"Registered": info.get("registered")})
  
def print_data(data):
    pprint(data)

def select_all_from_registrations(c):
   with c.conn.cursor() as cur:
      sql = "SELECT * FROM Registrations"
      cur.execute(sql)
      return cur.fetchall()

if __name__ == "__main__":        
    c = PortalConnection.PortalConnection()
        
    setup(c)

    print("Test 1:")
    print(c.getInfo("7777777777"))
    pause()

    print("Test 2:")
    print(c.register("7777777777", "CCC444"))
    pprint_info(c.getInfo("7777777777"))
    pause()

    print("Test 3:")
    print(c.register("7777777777", "CCC444"))
    pprint_info(c.getInfo("7777777777"))
    pause()

    print("Test 4:")
    print(c.unregister("7777777777", "CCC444"))
    pprint_info(c.getInfo("7777777777"))
    print()
    print(c.unregister("7777777777", "CCC444"))
    pprint_info(c.getInfo("7777777777"))
    pause()

    print("Test 5:")
    print(c.register("7777777777", "CCC777"))
    pprint_info(c.getInfo("7777777777"))
    pause()

    print("Test 6:")
    pprint_info(c.getInfo("5555555555"))
    print()
    print(c.unregister("5555555555", "CCC333"))
    pprint_info(c.getInfo("5555555555"))
    print()
    print(c.register("5555555555", "CCC333"))
    pprint_info(c.getInfo("5555555555"))
    pause()

    print("Test 7:")
    print(c.unregister("5555555555", "CCC333"))
    pprint_info(c.getInfo("5555555555"))
    print()
    print(c.register("5555555555", "CCC333"))
    pprint_info(c.getInfo("5555555555"))
    pause()

    print("Test 8:")
    print_data(select_all_from_registrations(c))
    print()
    print(c.unregister("2222222222", "CCC222"))
    # pprint_info(c.getInfo("2222222222"))
    print_data(select_all_from_registrations(c))
    pause()

    print("Test 9")
    print(c.register("7777777777", "CCC444"))
    PortalConnection.SECURE_EXECUTION = False
    sneaky_course_code_1 = """
      CCC444'; DELETE FROM Registered; DELETE FROM WaitingList WHERE 'a'='a
    """
    sneaky_course_code_2 = "CCC444'; DELETE FROM WaitingList WHERE 'a'='a"
    print(c.unregister("7777777777", sneaky_course_code_1))
    print(c.unregister("7777777777", sneaky_course_code_2))
    pprint_info(c.getInfo("7777777777"))
    print_data(select_all_from_registrations(c))

    # print("Test -1:")
    # print(c.register("7777777777", "CCC444"))
    # pprint_json(c.getInfo("7777777777"))
    # pause()

    # print("Test 0:")
    # print(c.unregister("7777777777", "CCC444"))
    # pprint_json(c.getInfo("7777777777"))
    # pause()

    # print("Test 1:")
    # # pprint_json(c.getInfo("2222222222"))
    # print(c.unregister("2222222222", "CCC333"))
    # pprint_json(c.getInfo("2222222222"))
    # pause()
    
    # print("Test 2:")
    # print(c.register("2222222222", "CCC333")); 
    # pprint_json(c.getInfo("2222222222"))
    # pause()

    # print("Test 3:")
    # print(c.unregister("6666666666", "CCC555")); 
    # pprint_json(c.getInfo("6666666666"))
    # pause()

    # print("Test 4:")
    # pprint_json(c.getInfo("4444444444"))
    # pause()

    # print("Test sju:")
    # print(c.register("7777777777", "CCC444")); 
    # pprint_json(c.getInfo("7777777777"))
    # pause()

    #########################################
    ##SQL INJECTION TESTING##################
    #########################################

    # PortalConnection.SECURE_EXECUTION = False
    # print("TEST otta:")
    # sneaky_course_code = """
    #   CCC444'; DELETE FROM Registered; DELETE FROM WaitingList WHERE 'a'='a
    # """
    # print(c.unregister("7777777777", sneaky_course_code))
    # # print(c.unregister("7777777777", "CCC444'; DELETE FROM Registered; DELETE FROM WaitingList WHERE 'a'='a"))
    # # print(c.unregister("7777777777' OR '1'='1", "CCC444' OR '1'='1"))
    # pprint_json(c.getInfo("7777777777"))
    
    