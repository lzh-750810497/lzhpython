# -*- coding=utf-8 -*-
# @Time:2021/3/18 10:07
# @Author:刘子恒
# @File: 金融界.py
# @Software: PyCharm
import requests
import re
import xlwt
book=xlwt.Workbook(encoding='utf-8')
sheet=book.add_sheet('四大银行',cell_overwrite_ok=True)
col_names=['bank_Id','bank_Name','days','end_Date','entr_Curncy_Name','entr_Min_Curncy','inc_Score','inner_Code','liq_Score','mat_Actu_Yld','months',"multiple","prd_Max_Yld","prd_Max_Yld_De","prd_Sname","prd_Type","rist_Score",'row',"sell_End_Date","sell_Org_Date","star","stk_Score"]
for i,col_name in zip(range(len(col_names)),col_names):
    sheet.write(0, i, col_name)

headers={
'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36'
}
url='http://bankpro.jrj.com.cn/json/f.jspa?'
def one_page(page_num):
    params={
        'size':'100',
        'pn':str(page_num),
        't': '{"yhmc":"200001593,200001581,200001221,200002159","st":"0","xsdq":"-1,-1","sort":"sell_org_date","order":"desc","wd":""}',
    }
    response=requests.get(url=url,headers=headers,params=params)
    text=response.text
    print(text)
    strs=re.findall('"bankProductList":(.*?)]',text,re.S)
    product_info=re.findall('{(.*?)}',strs[0][1:])
    product_format='"bank_Id":(.*?),"bank_Name":"(.*?)","days":"(.*?)","end_Date":"(.*?)","entr_Curncy_Name":"(.*?)","entr_Curncy_Type":.*?,"entr_Min_Curncy":"(.*?)","inc_Score":"(.*?)","inner_Code":(.*?),"liq_Score":"(.*?)","mat_Actu_Yld":"(.*?)","months":"(.*?)","multiple":"(.*?)","prd_Max_Yld":"(.*?)","prd_Max_Yld_De":"(.*?)","prd_Sname":"(.*?)","prd_Type":"(.*?)","rist_Score":"(.*?)","row":(.*?),"sell_End_Date":"(.*?)","sell_Org_Date":"(.*?)","star":(.*?),"state":.*?,"stk_Score":"(.*?)"'
    for product in product_info:
        infos=list(re.findall(product_format,product,re.S)[0])
        infos[7]='http://bank.jrj.com.cn/bankpro/product/'+infos[7]+'/'
        for j in range(len(infos)):
            sheet.write(int(infos[17]),j,infos[j])
for i in range(1,2):
    one_page(i)
    print('第%d页爬取成功'%i)
book.save('hahah.xls')