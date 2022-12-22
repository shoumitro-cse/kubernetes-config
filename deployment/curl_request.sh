# shell for loop
i=1
while [[ "$i" -le 20 ]]; do
	curl -X 'GET' http://10.100.180.113/
	i=$((i + 1))
done