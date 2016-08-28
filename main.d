#!/usr/bin/rdmd

import moeimg, std.net.curl, std.conv, std.string, std.stdio, std.file;

/*void main(string[] args) {
	auto a = getArticles(parse!uint(args[1]));
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
}*/

void main(string[] args) {
	int acount, icount;
	auto num = parse!uint(args[1]);
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
