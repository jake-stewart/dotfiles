import "./options"
import "./mappings"
import "./autocommands"
import "./colors"
import "./lazy"

// types
// @ts.nvim/stable
// @ts.nvim/nightly

// main package
// ts.nvim

// for plugins:
// npm run watch
// npm run build
// builds to lua/

// should use build script for main plugin

// generate should do what its doing to create a table
// then merge table with existing table from disk
// that way can edit table from disk willy nilly

// options:
// - watch
// - bytecode

// notes:
// boolean coersion works like lua
// compiler uses type information

// todo types:
// vim.lsp
// vim.F
// vim.secure
// vim.types
// vim.treesitter
// vim.treesitter.highlighter
// vim.treesitter.language
// vim.treesitter.query
// vim.uri
// vim.lpeg
// improve vim.regex

//done
// vim.ui
// vim.version
// vim.json
// vim.spell
// vim.mpack
// vim.fs
// vim.highlight

// not doing
// vim.health

// supports:
//  - vim.loop
//  - vim.o, vim.bo, vim.wo, vim.go
//  - vim.opt
//  - vim.keymap
//  - vim.api
//  - lua interoperability
//      - lua.pcall, lua.require, lua.table, lua.string, lua.io, lua.os, lua.math
//  - console

