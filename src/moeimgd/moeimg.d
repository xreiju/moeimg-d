module moeimgd.moeimg;

import std.stdio, std.regex, std.conv, std.string, std.traits, requests;

struct Article {
	string index;
	string name;

	this(string index, string name) {
		this.index = index;
		this.name = name;
	}
	this(char[] index, char[] name) {
		this.index = cast(string)index;
		this.name = cast(string)name;
	}

	string getURL() {
		return format("http://moeimg.net/%s.html", index);
	}
}

struct Image {
	string archive_num;
	string filename;
	Article article;

	this(string archive_num, string filename, Article article) {
		this.archive_num = archive_num;
		this.filename = filename;
		this.article = article;
	}
	this(char[] archive_num, char[] filename, Article article) {
		this.archive_num = cast(string)archive_num;
		this.filename = cast(string)filename;
		this.article = article;
	}
	string getURL() {
		return format("http://img.moeimg.net/wp-content/uploads/archives%s/%s/%s", archive_num, article.index, filename);
	}
}

Article[] getArticles(uint page) {
	Article[] result;
	try {
		auto content = to!string(getContent(format("http://moeimg.net/page/%d", page)));
		auto r = ctRegex!("<a href=\"http://moeimg.net/([0-9]+?).html\" title=\"(.+?)\">");
		foreach(c; matchAll(content, r)) {
			result ~= Article(c[1], c[2]);
		}

	} catch(Exception e) {
		stderr.writeln("An error occured");
		throw e;
	}
	return result;
}

Image[] getImages(Article article) {
	Image[] result;
	try {
		auto content = to!string(getContent(article.getURL()));
		auto r = regex(format("<a href=\"http://img.moeimg.net/wp-content/uploads/archives([0-9].*)/%s/(.+)\" target=\"_blank\">", article.index));
		foreach(c; matchAll(content, r)) {
			result ~= Image(c[1], c[2], article);
		}
	} catch(Exception e) {
		stderr.writeln("An error occured");
	}
	return result;
}
