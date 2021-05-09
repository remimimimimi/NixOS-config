{ config, pkgs, ... }:

let
  unstable = import <unstable> { config = { allowUnfree = true; }; };
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "remimimimi";
  home.homeDirectory = "/home/remimimimi";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";

  nixpkgs.overlays = [
    (
      import (
        builtins.fetchTarball {
          url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
        }
      )
    )
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;

    vimAlias = true;


    plugins = with pkgs.vimPlugins;
      let
        context-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "context-vim";
          version = "master";
          src = pkgs.fetchFromGitHub {
            owner = "wellle";
            repo = "context.vim";
            rev = "e38496f1eb5bb52b1022e5c1f694e9be61c3714c";
            sha256 = "1iy614py9qz4rwk9p4pr1ci0m1lvxil0xiv3ymqzhqrw5l55n346";
          };
        };
        vim-caser = pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "vim-caser";
          version = "master";
          src = pkgs.fetchFromGitHub {
            owner = "arthurxavierx";
            repo = "vim-caser";
            rev = "c66b8e8c2678d5446fed3a11bc02c762244608b5";
            sha256 = "nnL3sj3lqQvpvixduUImQ0xcb8B5klfLb6OmFhsxRiw=";
            fetchSubmodules = true;
          };
        };
        nvim-lsp-saga = pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "nvim-lsp-saga";
          version = "master";
          src = pkgs.fetchFromGitHub {
            owner = "ckipp01";
            repo = "lspsaga.nvim";
            rev = "185526658e6e8b11c2b1a268d98dbd28f46dad77";
            sha256 = "sha256-rbW9HlntH7GVgUUnPL7JZSdyRoqZdEQRZ8s1dkR7lkM=";
          };
        };
        nvim-compe = pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "nvim-compe";
          version = "master";
          src = pkgs.fetchFromGitHub {
            owner = "hrsh7th";
            repo = "nvim-compe";
            rev = "efe3a6614e74c5eafec89e5b256ea514c5e1ea15";
            sha256 = "EAi8jXllmGJIjrIbsEcvMPhzNWJkfIUleVkmVBFcyQI=";
            fetchSubmodules = true;
          };
        };
        spaceline-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "spaceline-vim";
          version = "master";
          src = pkgs.fetchFromGitHub {
            owner = "glepnir";
            repo = "spaceline.vim";
            rev = "94751d190a6912911c7789c1d5acb31a234bf22f";
            sha256 = "a9iCnzVe31wWBrdk9OzC+xV4PtX47G0eAsdzlAFcwf8=";
            fetchSubmodules = true;
          };
        };
      in
        [
          {
            plugin = vim-nix;
          }
          {
            plugin = gruvbox-community;
          }
          {
            plugin = easymotion;
            config = ''
              " <leader>f{char} to move to {char}
              map  <leader>f <Plug>(easymotion-bd-f)
              nmap <leader>f <Plug>(easymotion-overwin-f)

              " s{char}{char} to move to {char}{char}
              nmap s <Plug>(easymotion-overwin-f2)

              " " Move to line
              " map <leader>l <Plug>(easymotion-bd-jk)
              " nmap <leader>l <Plug>(easymotion-overwin-line)

              " Move to word
              map  <leader>w <Plug>(easymotion-bd-w)
              nmap <leader>w <Plug>(easymotion-overwin-w)
            '';
          }
          {
            plugin = context-vim;
            config = ''
              let g:context_enabled = 0
              nnoremap gc :ContextPeek<CR>
            '';
          }
          {
            plugin = nerdcommenter;
          }
          {
            plugin = auto-pairs;
            config = ''let g:AutoPairsFlyMode = 1'';

          }
          {
            plugin = vim-which-key;
            config = ''
              nnoremap <silent> <leader>      :WhichKey '<leader>'<CR>
              nnoremap <silent> <localleader> :WhichKey '<localleader'CR>
              "nnoremap <silent> g             :WhichKey 'g'<CR>
            '';
          }
          {
            plugin = vim-vsnip;
          }
          {
            plugin = vim-surround;
          }
          {
            plugin = vim-caser;
          }
          {
            plugin = vim-polyglot;
          }
          {
            plugin = vim-toml;
          }
          {
            plugin = vim-indent-guides;
            config = ''let g:indent_guides_enable_on_vim_startup = 1'';
          }
          #{
            #plugin = vimtex;
          #}
          #{
            #plugin = vim-visual-multi;
            #config = ''

            #'';
          #}
          {
            plugin = nvim-lspconfig;
            config = ''
              packadd! nvim-lspconfig
              lua << EOF
              local lspconfig = require('nvim_lsp')

              local capabilities = vim.lsp.protocol.make_client_capabilities()
              capabilities.textDocument.completion.completionItem.snippetSupport = true
              capabilities.textDocument.completion.completionItem.resolveSupport = {
                properties = {
                  'documentation',
                  'detail',
                  'additionalTextEdits',
                }
              }

              lspconfig.rust_analyzer.setup {
                capabilities  = capabilities ,
              }
              -- lspconfig.rust_analyzer.setup{
              --   settings = {
              --     rust-analyzer = { cargo = { target = "riscv64gc-unknown-none-elf"} }
              --   }
              -- }
              lspconfig.rnix.setup {}
              EOF
              " Format on save
              " let g:rustfmt_autosave = 1
              autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)
            '';
          }
          {
            plugin = nvim-lsp-saga;
            config = ''
              packadd! nvim-lsp-saga-master
              lua << EOF
              local saga = require('lspsaga')
              saga.init_lsp_saga {}
              require'lspsaga.diagnostic'.show_line_diagnostics()
              -- saga.init_lsp_saga {
              --   server_filetype_map = {
              --     metals = {
              --       'rs', "nix"
              --     }
              --   }
              -- }
              EOF


              " LSP provider to find the cursor word definition and reference
              nnoremap <silent><leader>lh :Lspsaga lsp_finder<CR>

              " Code action
              nnoremap <silent><leader>lca :Lspsaga code_action<CR>

              " Show signature help
              nnoremap <silent><leader>ls :Lspsaga signature_help<CR>

              " Rename
              nnoremap <silent><leader>lr :Lspsaga rename<CR>

              " Preview definition
              nnoremap <silent><leader>ld :Lspsaga preview_definition<CR>

              " Float terminal also you can pass the cli command in open_float_terminal function
              nnoremap <silent> <A-d> :Lspsaga open_floaterm<CR>
              tnoremap <silent> <A-d> <C-\><C-n>:Lspsaga close_floaterm<CR>

              "hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
              "hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
              "hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
              "augroup lsp_document_highlight
              "  autocmd! * <buffer>
              "  autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
              "  autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
              "augroup END
            '';
          }
          {
            plugin = nvim-compe;
            config = ''
              "packadd nvim-compe
              set completeopt=menuone,noselect

              lua << EOF
              require'compe'.setup {
                enabled = true;
                autocomplete = true;
                debug = false;
                min_length = 1;
                preselect = 'enable';
                throttle_time = 80;
                source_timeout = 200;
                incomplete_delay = 400;
                max_abbr_width = 1000;
                max_kind_width = 1000;
                max_menu_width = 1000000;
                documentation = true;

                source = {
                  path = true;
                  buffer = true;
                  calc = true;
                  vsnip = true;
                  nvim_lsp = true;
                  nvim_lua = true;
                  spell = true;
                  tags = true;
                  snippets_nvim = false;
                  treesitter = false;
                };
              }

              local t = function(str)
                return vim.api.nvim_replace_termcodes(str, true, true, true)
              end

              local check_back_space = function()
                  local col = vim.fn.col('.') - 1
                  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                      return true
                  else
                      return false
                  end
              end

              -- Use (s-)tab to:
              --- move to prev/next item in completion menuone
              --- jump to prev/next snippet's placeholder
              _G.tab_complete = function()
                if vim.fn.pumvisible() == 1 then
                  return t "<C-n>"
                elseif vim.fn.call("vsnip#available", {1}) == 1 then
                  return t "<Plug>(vsnip-expand-or-jump)"
                elseif check_back_space() then
                  return t "<Tab>"
                else
                  return vim.fn['compe#complete']()
                end
              end
              _G.s_tab_complete = function()
                if vim.fn.pumvisible() == 1 then
                  return t "<C-p>"
                elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
                  return t "<Plug>(vsnip-jump-prev)"
                else
                  return t "<S-Tab>"
                end
              end

              vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
              vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
              vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
              vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
              EOF
            '';
          }
          {
            plugin = unstable.vimPlugins.nvim-web-devicons;
          }
          {
            plugin = spaceline-vim;
            config = ''
              let g:spaceline_seperate_style = 'none'
              let g:spaceline_colorscheme = 'nord'
            '';
          }
          {
            plugin = nord-vim;
            config = ''
              set termguicolors
              colorscheme nord
            '';
          }
        ];

    extraConfig = ''
      let g:mapleader = ","
      nnoremap "," <Nop>

      " Proper serach
      set incsearch
      set ignorecase
      set smartcase
      set gdefault

      " Easy exit
      inoremap jj <ESC>

      " Jump to start and end of line using the home row keys
      nnoremap L $
      nnoremap H ^

      " Neat X clipboard integration
      " ,p will paste clipboard into buffer
      " ,y will copy entire buffer into clipboard
      noremap <leader>p :read !xsel --clipboard --output<cr>
      noremap <leader>y :w !xsel -ib<cr><cr>

      " No arrow keys --- force yourself to use the home row
      nnoremap <up> <nop>
      nnoremap <down> <nop>
      inoremap <up> <nop>
      inoremap <down> <nop>
      inoremap <left> <nop>
      inoremap <right> <nop>

      " Left and right can switch buffers
      nnoremap <left> :bp<CR>
      nnoremap <right> :bn<CR>

      " Various mappings
      nnoremap ; :
      set undofile

      " TAB
      set tabstop=4 shiftwidth=4 noexpandtab smarttab

      " Disable vi compatability
      set nocompatible

      " Enable Normal mode keys in ru layout
      set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

      " NUMBERS
      set number relativenumber

      augroup numbertoggle
        autocmd!
        autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
        autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
      augroup END

      " S PEE D
      set ttyfast
      set lazyredraw
    '';
  };

  programs.alacritty = {
    enable = true;
    package = unstable.alacritty;
    settings = {
      font= {
        normal = {
          family = "Roboto Mono Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "Roboto Mono Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "Roboto Mono Nerd Font Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "Roboto Mono Nerd Font Mono";
          style = "Bold Italic";
        };

        size = 11.0;
        offset = {
          x = 1;
          y = 1;
        };
      };

      colors = {
        # Default colors
        primary = {
          background = "0x000000";
          foreground = "0xffffff";
        };
        cursor = {
          text = "0xF81CE5";
          cursor = "0xffffff";
        };

        # Normal colors
        normal = {
          black =   "0x000000";
          red =     "0xfe0100";
          green =   "0x33ff00";
          yellow =  "0xfeff00";
          blue =    "0x0066ff";
          magenta = "0xcc00ff";
          cyan =    "0x00ffff";
          white =   "0xd0d0d0";
        };
        # Bright colors
        bright = {
          black =   "0x808080";
          red =     "0xfe0100";
          green =   "0x33ff00";
          yellow =  "0xfeff00";
          blue =    "0x0066ff";
          magenta = "0xcc00ff";
          cyan =    "0x00ffff";
          white =   "0xFFFFFF";
        };
      };

      cursor = {
        style = {
          shape = "Block";
          blinking = "On";
        };

        blink_interval = 750;
        unfocused_hollow = true;
      };

      shell = {
        program = "zsh";
      };
    };
  };
}
