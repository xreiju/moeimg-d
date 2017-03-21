import moeimgd, std.net.curl, std.conv, std.string, std.stdio, std.file;

void main(string[] args) {
	string usage =
"Usage: <cmd> <mode(1 or 2)> <argument>
Need to know what should I use as the argument? Just check the source codes :)";

	if(args.length <= 1) {
		writeln("You must enter at least 2 arguments.");
		writeln(usage);
		return;
	}
	switch(args[1]) {
		case "1":
			func1(args);
			break;
		case "2":
			func2(args);
			break;
		default:
			writeln("the mode does't exist.");
			writeln(usage);
			return;
	}
}
void func1(string[] args) {
	int acount, icount;
	auto num = parse!uint(args[2]);
	foreach(i; 0..num) {
		auto articles = getArticles(i+1);
		acount += articles.length;
		foreach(j, article; articles) {
			writeln(article.name, '\t', j, '/', articles.length, "\t...");
			icount += getImages(article).length;
		}
		writeln("done!");
	}
	writeln(acount, '\t', icount);
	writeln(format("average: %s", cast(double)icount/cast(double)acount));
}

void func2(string[] args) {
	auto a = getArticles(parse!uint(args[2]));
	if(!exists("imgs")) mkdir("imgs");

	foreach(article; a) {
		auto dir = format("imgs/%s", article.name);
		if(!exists(dir)) mkdir(dir);
		auto images = getImages(article);

		foreach(image; images) {
			auto file = format("%s/%s", dir, image.filename);
			if(!exists(file)) {
				download(image.getURL(), file);
				writeln("done: ", image.filename);
			} else {
				writeln("exists: ", image.filename);
			}
		}
	}
}
