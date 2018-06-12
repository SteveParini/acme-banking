'use strict';
var fs = require('fs')


// Get the trufflehog output
var th = new Array()

process.stdin.setEncoding('utf-8');

const cp = require('child_process')

const output = cp.spawnSync('/usr/local/bin/trufflehog', [ '.' , '--json' ], [{cwd: process.cwd() }])

console.log(output.stdout.toString('utf8').split(/\n+/).filter((row) => {
    return row.match(/^\{.+\}$/)
}).map((row) => {
    return JSON.parse(row)
}).map((entry) => {
    return entry.stringsFound.map((string) => {
    	th.push(string)
        return {
            filename: entry.path,
            string: string
        }
    })
}))


// Read the whitelist from the file
var whitelist = new Array()

fs.readFile ('./whitelist', function read(err, data) {
    if (err) {
        throw err;
    }

	// Whitelisting the trufflehog output
    whitelist = data.toString().split(',');
    const result = th.filter( st => whitelist.indexOf(st)!=-1)
		fs.writeFile ('./result', result, function write(err, data1) {
	    if (err) {
	        throw err;
	    }
	    console.log(result)
	});
});
