import PortalConnection

def setup(c):
   with c.conn.cursor() as cur:
      cur.execute(open("../Lab_3/setup.sql", "r").read())
      cur.execute(open("../Lab_3/triggers.sql", "r").read())

def pause():
  input("Press Enter to continue...")
  print("")

if __name__ == "__main__":        
    c = PortalConnection.PortalConnection()
        
    setup(c)

    print("Test 1:")
    print(c.unregister("2222222222", "CCC333"))
    print(c.getInfo("2222222222"))
    pause()
    
    print("Test 2:")
    print(c.register("2222222222", "CCC333")); 
    print(c.getInfo("2222222222"))
    pause()

    print("Test 3:")
    print(c.unregister("6666666666", "CCC555")); 
    print(c.getInfo("6666666666"))
    pause()
    
    