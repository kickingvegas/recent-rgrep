##
# Copyright 2025 Charles Y. Choi
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

##
# Install Instructions

# 1. Edit INSTALL_DIR and optionally ELISP_DIR to preferred locations.
# 2. Run `make install` to install `recent-rgrep` in INSTALL_DIR
# 3. Run `make install-el` to install `recent-rgrep.el` in ELISP_DIR

# Edit INSTALL_DIR to directory where script recent-rgrep will be stored.
INSTALL_DIR=$(HOME)/bin

# Edit ELISP_DIR to directory to store recent-rgrep.el
ELISP_DIR=$(HOME)/emacs

TIMESTAMP := $(shell /bin/date "+%Y%m%d_%H%M%S")

EXEC_NAME=recent-rgrep
EXEC_SRC=$(EXEC_NAME).sh

$(INSTALL_DIR):
	mkdir $(INSTALL_DIR)

.PHONY: install
install: $(INSTALL_DIR)/$(EXEC_NAME)

$(INSTALL_DIR)/$(EXEC_NAME): $(INSTALL_DIR) $(EXEC_SRC)
	cp -f $(EXEC_SRC) $(INSTALL_DIR)/$(EXEC_NAME)
	chmod uog+x $(INSTALL_DIR)/$(EXEC_NAME)

.PHONY: uninstall
uninstall:
	rm $(INSTALL_DIR)/$(EXEC_NAME)

.PHONY: install-el
install-el: $(ELISP_DIR)/$(EXEC_NAME).el

$(ELISP_DIR)/$(EXEC_NAME).el: $(EXEC_NAME).el
	cp $(EXEC_NAME).el $(ELISP_DIR)

.PHONY: uninstall-el
uninstall-el:
	rm $(ELISP_DIR)/$(EXEC_NAME).el
