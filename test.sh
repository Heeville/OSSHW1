echo "----------------------------------
User Name: HONG JINUK
Student Number: 12191198
[ MENU ]
1. Get the data of the movie identified by a specific 
'movie id' from 'u.item'
2. Get the data of action genre movies from 'u.item’
3. Get the average 'rating’ of the movie identified by 
specific 'movie id' from 'u.data’
4. Delete the ‘IMDb URL’ from ‘u.item
5. Get the data about users from 'u.user’
6. Modify the format of 'release date' in 'u.item’i
7. Get the data of movies rated by a specific 'user id' 
from 'u.data'
8. Get the average 'rating' of movies rated by users with 
'age' between 20 and 29 and 'occupation' as 'programmer'
9. Exit
----------------------------------"
stop="N"

until [ $stop = "Y" ]
do
	read -p "Enter your choice [ 1-9 ] " choice
	echo -e ""
	case $choice in
	1)
		read -p "Please enter 'movie id'(1~1682) :" num
		awk -v movie_id="$num" -F '|' '$1 == movie_id {print $0}' u.item
		echo -e ""
		;;
	2)
		read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n) :" yn
		echo -e ""
		if [ $yn = "y" ]
		then
			awk -F '|' '$7==1 {print $1, $2}' u.item | head -n 10
		fi
		echo -e ""
		;;

	3) 
		read -p "Please enter 'movie id'(1~1682) :" num 
		awk -v movie_id="$num" -F '\t' '$2 == movie_id { sum += $3; denom++ } 
		END { if (denom > 0) printf("average rating of %d : %.5f",movie_id,sum / denom) }' u.data
		echo -e "\n"
		;;
	4)
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n) " yn
		echo -e ""
		if [ $yn = "y" ]
		then
			sed -E 's/http[^\|]*\|/\|/' u.item |head -n 10
		fi
		echo -e ""
		;;
	5)
		read -p "Do you want to get the data about users from 'u.user'?(y/n) " yn
		echo -e ""
		if [ $yn = "y" ]
		then
			awk -F '|' '{printf "user %d is %d years old %s %s\n",$1,$2,$3,$4}' u.user | sed 's/M/male/ ; s/F/female/'|head -n 10
		fi
		echo -e ""
		;;
	6)
		read -p "Do yout want to Modify the format of 'release data' in 'u.item'?(y/n) :" yn
		echo -e ""
		if [ $yn = "y" ]
		then
			sed -E 's/([0-9]{2})-([a-zA-Z]{3})-([0-9]{4})/\3\2\1/' u.item | sed -e 's/Jan/01/ ;s/Feb/02/ ; s/Mar/03/ ; s/Apr/04/ ; s/May/05/ ; s/Jun/06/ ; s/Jul/07/ ; s/Aug/08/ ; s/Sep/09/ ; s/Oct/10/; s/Nov/11/ ; s/Dec/12/' | tail -n 10
		fi
		echo -e ""
		;;
	7)
		read -p "Please enter the 'user id' (1~943) :" num
		echo -e ""
		user_rate=$(awk -v userid="$num" -F '\t' '$1==userid {print $2}' u.data | sort -n)
		echo -e "$user_rate" | tr  '\n' '|'
		echo -e "\n"
		awk -v movie_id="$user_rate" -F '|' 'BEGIN { split(movie_id, movies,"\n"); } 
		{for (i in movies) 
			{if ($1 == movies[i]) 
				{id[i] = $1; name[i] =$2;}}} 
			END {for (j in id) 
				{printf ("%d|%s\n", id[j], name[j]);}}' u.item | head -n 10
		echo -e ""
		;;
	8)
		read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n) :" yn
		echo -e ""
		if [ $yn = "y" ]; 
		then
			twenties_pg_user=$(awk -F '|' '$2 >= 20 && $2 <= 29 && $4 == "programmer" {print $1 }' u.user)
			awk -v users="$twenties_pg_user" -F '\t' 'BEGIN { split(users, user_id, "\n"); } 
			{for (i in user_id) 
				{ if ($1 == user_id[i]) 
					{ sum[$2] += $3; denom[$2]++;}}} 
				END { for(j in sum) 
					{ if (denom[j] > 0) 
					
						{ printf("%d %.5f\n", j, sum[j] / denom[j]);}}}' u.data | sort -n
		fi
		echo -e ""
		;;
	9)
		echo "Bye!"
		stop="Y"
		;;

	esac
done
