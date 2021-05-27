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

  # home.file.".icons/default".source = "${pkgs.bibata-cursors}/share/icons/Vanilla-DMZ";

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
        nvim-comment = pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "nvim-comment";
          version = "master";
          src = pkgs.fetchFromGitHub {
            owner = "terrortylor";
            repo = "nvim-comment";
            rev = "e7de7abf17204424065b926a9031f44b47efbf4a";
            sha256 = "sbkjR33SDegwGHxbWLbJsMiI33xV6J+LB6nYW6UOo6Y=";
            fetchSubmodules = true;
          };
        };
        hydrangea-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "hydrangea-vim";
          version = "master";
          src = pkgs.fetchFromGitHub {
            owner = "yuttie";
            repo = "hydrangea-vim";
            rev = "d07255fc06a251ee0be0b85fc4db3a69d8e2ee55";
            sha256 = "Yh3Jjw9hAKf2b43O34TpEWDY5Sfhjo3aeMPlZlgwDgQ=";
            fetchSubmodules = true;
          };
        };
        rust-tools-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
          pname = "rust-tools-nvim";
          version = "master";
          src = pkgs.fetchFromGitHub {
            owner = "simrat39";
            repo = "rust-tools.nvim";
            rev = "2de94fc88d6382e5f0b61f1c619c8919fd45aea3";
            sha256 = "TitmO3KtbIhIfndNdggr3SWJrWcPXavb/boLHzQGz5E=";
            fetchSubmodules = true;
          };
        };
      in
        [
          vim-vsnip
          vim-surround
          vim-caser
          vim-polyglot
          vim-toml
          vim-nix
          unstable.vimPlugins.nvim-web-devicons
          {
            plugin = easymotion;
            config = ''
              " " <leader>f{char} to move to {char}
              " map  <leader>f <Plug>(easymotion-bd-f)
              " nmap <leader>f <Plug>(easymotion-overwin-f)

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
              nnoremap gi :ContextPeek<CR>
            '';
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
              " nnoremap <silent> g             :WhichKey 'g'<CR>
            '';
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
          #}
          {
            plugin = unstable.vimPlugins.nvim-lspconfig;
            config = ''
              packadd! nvim-lspconfig
              lua << EOF
              local lspconfig = require('lspconfig')
              -- local lspconfig = require('nvim_lsp')

              local capabilities = vim.lsp.protocol.make_client_capabilities()
              capabilities.textDocument.completion.completionItem.snippetSupport = true
              -- capabilities.textDocument.completion.completionItem.resolveSupport = {
              --   properties = {
              --     'documentation',
              --     'detail',
              --     'additionalTextEdits',
              --   }
              -- }

              lspconfig.rust_analyzer.setup {
                capabilities = capabilities,
              }

              lspconfig.rnix.setup {}
              vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                  virtual_text = true,
                  signs = true,
                  update_in_insert = true,
                }
              )
              EOF
            '';
          }
          {
            plugin = nvim-lsp-saga;
            config = ''
              packadd! nvim-lsp-saga-master
              lua << EOF
              local saga = require('lspsaga')
              saga.init_lsp_saga {
                error_sign = "",
                warn_sign = "",
                hint_sign = "",
                infor_sign = "",
                code_action_icon = "",
                -- code_action_icon = " ",
              }
              EOF


              " LSP provider to find the cursor word definition and reference
              nnoremap <silent><leader>lh :Lspsaga lsp_finder<CR>

              " Code action
              nnoremap <silent><leader>la :Lspsaga code_action<CR>

              " Show hover documentation
              nnoremap <silent>K :Lspsaga hover_doc<CR>

              " scroll down hover doc or scroll in definition preview
              nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
              " scroll up hover doc
              nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>

              " Rename
              nnoremap <silent><leader>lr :Lspsaga rename<CR>

              " Preview definition
              nnoremap <silent><leader>ld :Lspsaga preview_definition<CR>

              " Float terminal also you can pass the cli command in open_float_terminal function
              nnoremap <silent> <A-d> :Lspsaga open_floaterm<CR>
              tnoremap <silent> <A-d> <C-\><C-n>:Lspsaga close_floaterm<CR>
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
                  snippets_nvim = true;
                  treesitter = false;
                };
              }

              EOF
              " Use <Tab> and <S-Tab> to navigate through popup menu
              inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
              inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

              inoremap <silent><expr> <C-Space> compe#complete()
              inoremap <silent><expr> <CR>      compe#confirm('<CR>')
              inoremap <silent><expr> <C-e>     compe#close('<C-e>')
            '';
          }
          {
            plugin = rust-vim;
            config = ''
              " Format on save
              let g:rustfmt_autosave = 1
              " autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)
            '';
          }
          {
            plugin = nvim-comment;
            config = ''
              lua << EOF
              require('nvim_comment').setup()
              EOF
            '';
          }
          {
            plugin = lightline-vim;
            config = ''
              let g:lightline = {
                  \ 'colorscheme': 'hydrangea',
                  \ 'component': {
                  \   'readonly': '%{&readonly?"":""}',
                  \ },
                  \ 'separator':    { 'left': '', 'right': '' },
                  \ 'subseparator': { 'left': '', 'right': '' },
                  \ }
            '';
          }
          {
            plugin = hydrangea-vim;
            config = ''
              set termguicolors
              colorscheme hydrangea
            '';
          }
          {
            plugin = rust-tools-nvim;
            config = ''
              lua << EOF
              local opts = {
                  tools = { -- rust-tools options
                      -- automatically set inlay hints (type hints)
                      -- Therekis an issue due to which the hints are not applied on the first
                      -- opened file. For now, write to the file to trigger a reapplication of
                      -- the hints or just run :RustSetInlayHints.
                      -- default: true
                      autoSetHints = true,

                      -- whether to show hover actions inside the hover window
                      -- this overrides the default hover handler
                      -- default: true
                      hover_with_actions = true,

                      runnables = {
                          -- whether to use telescope for selection menu or not
                          -- default: true
                          -- use_telescope = true
                          use_telescope = false

                          -- rest of the opts are forwarded to telescope
                      },

                      inlay_hints = {
                          -- wheter to show parameter hints with the inlay hints or not
                          -- default: true
                          show_parameter_hints = true,

                          -- prefix for parameter hints
                          -- default: "<-"
                          parameter_hints_prefix = "<-",

                          -- prefix for all the other hints (type, chaining)
                          -- default: "=>"
                          other_hints_prefix  = "=>",

                          -- whether to align to the lenght of the longest line in the file
                          max_len_align = false,

                          -- padding from the left if max_len_align is true
                          max_len_align_padding = 1,

                          -- whether to align to the extreme right or not
                          right_align = false,

                          -- padding from the right if right_align is true
                          right_align_padding = 7,
                      },

                      hover_actions = {
                          -- the border that is used for the hover window
                          -- see vim.api.nvim_open_win()
                          border = {
                            {"╭", "FloatBorder"},
                            {"─", "FloatBorder"},
                            {"╮", "FloatBorder"},
                            {"│", "FloatBorder"},
                            {"╯", "FloatBorder"},
                            {"─", "FloatBorder"},
                            {"╰", "FloatBorder"},
                            {"│", "FloatBorder"}
                          },
                      }
                  },

                  -- all the opts to send to nvim-lspconfig
                  -- these override the defaults set by rust-tools.nvim
                  -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
                  server = {}, -- rust-analyer options
              }

              require('rust-tools').setup(opts)
              EOF
            '';
          }
          # Broken in neovim HEAD
          # {
          #   plugin = unstable.vimPlugins.telescope-nvim;
          #   config = ''
          #     lua << EOF
          #     EOF
          #     nnoremap <leader>ff <cmd>Telescope find_files<cr>
          #     nnoremap <leader>fg <cmd>Telescope live_grep<cr>
          #     nnoremap <leader>fb <cmd>Telescope buffers<cr>
          #     nnoremap <leader>fh <cmd>Telescope help_tags<cr>
          #   '';
          # }
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
      nmap L $
      nmap H ^

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
