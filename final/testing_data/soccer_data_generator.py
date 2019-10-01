import random
import pandas as pd

filename = "soccer_test_data_big.sql"
numTeams = 1000
numMatches = 100000

hlist = [] #hteam
vlist = [] #vteam
s1_list = [] #home score
s2_list = [] #visit team score
for i in range(1,numMatches):
    h = random.randrange(1,numTeams+1)
    v = random.randrange(1,numTeams+1)
    # a team cannot play itself
    if (h != v):
        hlist.append(h)
        vlist.append(v)
                     
    s1_list.append(random.randrange(0,6))
    s2_list.append(random.randrange(0,6))
    
df = pd.DataFrame([hlist, vlist, s1_list, s2_list]).T
#do not want duplicate matches (home,away) teams
df = df.drop_duplicates(subset=[0, 1])
df = df.dropna()
df = df.astype(int)

f= open(filename,"w+")


#insert some corner cases to test
f.write("INSERT INTO teams (name, coach) VALUES ('ateam', 'a');\n")
# insert a team who plays in no game
f.write("INSERT INTO teams (name, coach) VALUES ('ryan_team', 'ryan');\n")
# insert team whole plays only in one match as away team and loses
f.write("INSERT INTO teams (name, coach) VALUES ('bob_team', 'bob');\n")
f.write("INSERT INTO matches (hTeam, vTeam, hScore, vScore) VALUES ('ateam', 'bob_team', 2, 0);\n")
# insert team whole plays only in one match as home team and ties
f.write("INSERT INTO teams (name, coach) VALUES ('joe_team', 'joe');\n")
f.write("INSERT INTO matches (hTeam, vTeam, hScore, vScore) VALUES ('joe_team', 'ateam', 2, 2);\n")
# insert team whole plays only in one match as home team and wins
f.write("INSERT INTO teams (name, coach) VALUES ('pal_team', 'pal');\n")
f.write("INSERT INTO matches (hTeam, vTeam, hScore, vScore) VALUES ('pal_team', 'ateam', 4, 1);\n")


for i in range(1,numTeams+1):
    val = "INSERT INTO teams (name, coach) VALUES ('team{0}', 'coach{1}');\n".format(i,i)
    f.write(val)

for i in range(len(df)):
    h = int(df.iloc[i,0])
    v = int(df.iloc[i,1])
    s1 = int(df.iloc[i,2])
    s2 = int(df.iloc[i,3])
    val = "INSERT INTO matches (hTeam, vTeam, hScore, vScore) VALUES ('team{0}', 'team{1}', {2}, {3});\n".format(h,v,s1,s2)
    f.write(val)

f.close()
