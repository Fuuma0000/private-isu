all: app

app: *.go go.mod go.sum
	go build -o app

indb:
	mysql -u isuconp -p suconp 
