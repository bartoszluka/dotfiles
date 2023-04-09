return {
    on_attach = function(client, bufnr)
        local nmap = function(keys, func, desc)
            if desc then
                desc = "LSP: " .. desc
            end

            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end
        nmap("<leader>r", vim.lsp.buf.rename, "[R]ename")
        nmap("<leader>a", vim.lsp.buf.code_action, "Code [A]ction")

        nmap("gd", "<cmd>TroubleToggle lsp_definitions<cr>", "[G]oto [D]efinition")
        nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        nmap("gr", "<cmd>TroubleToggle lsp_references<cr>", "[G]oto [D]efinition")
        nmap("<leader>ls", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
        nmap("<leader>lS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

        -- this might be wrong
        vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
            if vim.lsp.buf.format then
                vim.lsp.buf.format()
            elseif vim.lsp.buf.formatting then
                vim.lsp.buf.formatting()
            end
        end, { desc = "Format current buffer with LSP" })
        nmap("<leader>f", "<cmd>Format<CR>", "Format file")
        -- See `:help K` for why this keymap
        -- nmap("K", vim.lsp.buf.hover, "Hover Documentation")
        -- nmap("gh", vim.lsp.buf.signature_help, "Signature Documentation")
        nmap("gh", vim.diagnostic.open_float, "Open diagnostic")

        -- Lesser used LSP functionality
        nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
        nmap("<leader>ha", vim.lsp.codelens.run, { buffer = bufnr, desc = "code lens" })
        -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        -- nmap('<leader>wl', function()
        --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, '[W]orkspace [L]ist Folders')
        -- NOTE: hacky workaround for semantic tokens
        -- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483
        if client.name == "omnisharp" then
            client.server_capabilities.semanticTokensProvider = {
                full = vim.empty_dict(),
                legend = {
                    tokenModifiers = { "static_symbol" },
                    tokenTypes = {
                        "comment",
                        "excluded_code",
                        "identifier",
                        "keyword",
                        "keyword_control",
                        "number",
                        "operator",
                        "operator_overloaded",
                        "preprocessor_keyword",
                        "string",
                        "whitespace",
                        "text",
                        "static_symbol",
                        "preprocessor_text",
                        "punctuation",
                        "string_verbatim",
                        "string_escape_character",
                        "class_name",
                        "delegate_name",
                        "enum_name",
                        "interface_name",
                        "module_name",
                        "struct_name",
                        "type_parameter_name",
                        "field_name",
                        "enum_member_name",
                        "constant_name",
                        "local_name",
                        "parameter_name",
                        "method_name",
                        "extension_method_name",
                        "property_name",
                        "event_name",
                        "namespace_name",
                        "label_name",
                        "xml_doc_comment_attribute_name",
                        "xml_doc_comment_attribute_quotes",
                        "xml_doc_comment_attribute_value",
                        "xml_doc_comment_cdata_section",
                        "xml_doc_comment_comment",
                        "xml_doc_comment_delimiter",
                        "xml_doc_comment_entity_reference",
                        "xml_doc_comment_name",
                        "xml_doc_comment_processing_instruction",
                        "xml_doc_comment_text",
                        "xml_literal_attribute_name",
                        "xml_literal_attribute_quotes",
                        "xml_literal_attribute_value",
                        "xml_literal_cdata_section",
                        "xml_literal_comment",
                        "xml_literal_delimiter",
                        "xml_literal_embedded_expression",
                        "xml_literal_entity_reference",
                        "xml_literal_name",
                        "xml_literal_processing_instruction",
                        "xml_literal_text",
                        "regex_comment",
                        "regex_character_class",
                        "regex_anchor",
                        "regex_quantifier",
                        "regex_grouping",
                        "regex_alternation",
                        "regex_text",
                        "regex_self_escaped_character",
                        "regex_other_escape",
                    },
                },
                range = true,
            }
        end
    end,
    -- nvim-cmp supports additional completion capabilities
    capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    servers = {
        "rust_analyzer",
        "pyright",
        "tsserver",
        "lua_ls",
        "omnisharp",
    },
}
