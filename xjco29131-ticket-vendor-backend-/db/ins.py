import sqlite3
import re
from random import shuffle

conn = sqlite3.connect('movie.db')


def write_data(conn_in, sql, data):
    c_in = conn_in.cursor()
    c_in.execute(sql, data)


x = 12
y = 16







sql_1 = 'select film_id, classification from movie limit 28, 100'
sql_2 = 'select cid, cname from classification'
sql_3 = 'insert into film_classification (fid, cid) VALUES(?, ?)'
c = conn.cursor()
c.execute(sql_1)
data = c.fetchall()
c.execute(sql_2)
data_class = c.fetchall()
final_arr = []

for val in data:
    class_arr = val[1].lower().split(' ')
    for val_c in class_arr:
        flag = False
        for class_val in data_class:
            if val_c == class_val[1]:
                flag = True
                final_arr.append([val[0], class_val[0]])
        if not flag:
            print(val[0])
print(final_arr)
for val in final_arr:
    conn.execute(sql_3, val)
conn.commit()

# sql_station = 'INSERT INTO movie(title, director, starring, blurb, classification, rank, release_time, ' \
#               'running_time, is_released, poster) VALUES (?, ?, ?, ?, ?, ? ,?, ?, ?, ?)'
# f = open("douban.csv", "r", encoding='utf-8')
# lines = f.readlines()
# shuffle(lines)
# for line in lines:
#     line_arr = line.split(',')
#     star = re.split('jpg|-',line_arr[4].replace(' / ','/'))
#     count = 0
#     s_arr = []
#     for val in star:
#         count += 1
#         if count % 2 != 0 and val != '' and len(val) < 20:
#             s_arr.append(val)
#
#     star_arr = str(s_arr)[1:-1].replace("'", "").replace("  ", "")
#     write_data(conn, sql_station, [line_arr[1], line_arr[3], star_arr, line_arr[8],
#                                    line_arr[9], line_arr[11], line_arr[5][2:-2], line_arr[6][2:-2][:-8],
#                                    1, line_arr[2]])
# conn.commit()
#
# # sql = 'SELECT birth FROM users'
# # c = conn.cursor()
# # c.execute(sql, None)
# # print(c.fetchall())
