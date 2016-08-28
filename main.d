#!/usr/bin/rdmd

import moeimg, std.net.curl, std.conv, std.string, std.stdio, std.file;

void main(string[] args) {
	auto a = getArticles(parse!uint(args[1]));
	auto b = getImages(a[0]);
	if(!exists("imgs")) mkdir("imgs");
	foreach(c; b) {
		auto file = format("imgs/%s", c.filename);
		if(!exists(file)) {
			download(c.getURL(), file);
			writeln("done: ", c.filename);
		} else {
			writeln("exists: ", c.filename);
		}
	}
}
