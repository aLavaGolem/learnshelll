#!/bin/bash
count=0
`:>1`
function next()
{
	if [ "http://www.baidu.com" != "$1" -a "$count" -ne "1" ];then
		#echo $1
		a=`curl -s -L -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8&Accept-Encoding: gzip, deflate, br&Cookie: BAIDUID=48B2AF5ED40D1371E76C1ACE0F817C30:FG=1; BIDUPSID=48B2AF5ED40D1371E76C1ACE0F817C30; PSTM=1574388367; H_PS_PSSID=1443_21087_29568_29221_22159; BD_UPN=13314352; BDORZ=B490B5EBF6F3CD402E515D22BCDA1598; H_PS_645EC=c5feLwyUJfz9VlqzlE%2BsgWfLPUm1j6UKauuzrfnB4xlBlfjJgip92aewuEU; delPer=0; BD_CK_SAM=1; PSINO=7" $1`
		#echo "$a"
		txt=`echo "$a" | sed "s/<.--.*-->//g" | tr "\r\n" "  " | tr '	' ' ' | tr -s ' ' | grep -o -P "\<h3 class=\"t.*?\</h3\>" | tr ' ' '#'`
		titles=()
		urls=()
		
		for h in $txt
		do
			#echo $h
			#标题
			title=`echo $h | grep -o -P "\>.*?\<" | tr '<>' '  '`
			title=`echo -e "$title" | tr ' \n' '##' | sed "s/#//g"`
			titles+=("$title")
			#url
			url=`echo $h | grep -o -P "http.*?link.*?\"" | sed "s/\"//g"`
			
			if [ ! -z "$url" ];then
				url2=`curl -s -f -I -L $url | grep -o  http.* | head -n 1`
				echo "$url2 $title"
				`echo "$url2 $title" >>1`
			fi
		done
		#页数
		let count++
		echo 下一页
		nextPage=`echo $a | grep -o -P "class=\"c-icon c-icon-bear-pn\".*?class=\"n\"" | grep -o -P "href=\".*?\"" | tail -n 1 | sed "s/\"//g"`
		next http://www.baidu.com${nextPage:5:${#nextPage}}
	else
		echo 退出
		exit 0
	fi

}
a='http://www.baidu.com/s?ie=utf-8&mod=1&isbd=1&isid=b30840680012a021&ie=utf-8&f=8&rsv_bp=1&tn=baidu&wd=zzzzz&oq=11111111111111111111yyyy&rsv_pq=b30840680012a021&rsv_t=d951v0uvjB1KjKzyiO3SGHDYGkGy4Qf8vRyiB4knscXSi8HNH%2FcXr7ouB2w&rqlang=cn&rsv_enter=0&rsv_dl=tb&prefixsug=11111111111111111111yyyy&rsp=0&bs=11111111111111111111yyyy&rsv_sid=undefined&_ss=1&clist=&hsug=&f4s=1&csor=0&_cr1=29412'
next $a











