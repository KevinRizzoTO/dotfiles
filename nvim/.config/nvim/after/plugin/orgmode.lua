require('orgmode').setup {
  org_agenda_files = {'~/org/**/*'},
  org_default_notes_file = '~/org/refile.org',
  org_indent_mode = 'ident',
  org_capture_templates = {
    t = "Todo",
    tt = {
      description = 'Blank',
      template = '* TODO %?\n  %t',
      target = '~/org/todo.org'
    },
    ts = {
      description = 'Blank w/ SCHEDULED',
      template = '* TODO %?\n  SCHEDULED: %t',
      target = '~/org/todo.org'
    },
    td = {
      description = 'Blank w/ DEADLINE',
      template = '* TODO %?\n  DEADLINE: %t',
      target = '~/org/todo.org'
    },
    tl = {
      description = 'w/ file line',
      template = '* TODO %?\n  %t\n  %a',
      target = '~/org/todo.org'
    },
    j = {
      description = 'Journal',
      template = '\n*** %U \n\n%?',
      target = '~/org/journal.org'
    },
    n = "Note",
    nb = {
      description = 'Blank',
      template = '\n* %?',
      target = '~/org/refile.org',
      headline = 'Blank'
    },
    nl = {
      description = 'w/ file line',
      template = '\n* %?\n%a',
      target = '~/org/refile.org',
      headline = 'w/ file line'
    },
    nc = {
      description = 'w/ code block',
      template = '\n* %?\n  %U\n  #+begin_src %( return vim.bo.filetype )\n  %x  #+end_src\n\n  %a',
      target = '~/org/refile.org',
      headline = 'w/ code block'
    }
  },
  mappings = {
    capture = {
      org_capture_finalize = '<Leader>w',
      org_capture_refile = 'R',
      org_capture_kill = 'Q'
    }
  }
}
