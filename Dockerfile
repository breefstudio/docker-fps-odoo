FROM odoo:13 AS build
USER root

RUN python3 -m pip list

RUN apt update
RUN apt install -y build-essential python3-dev python3-wheel libffi-dev rustc
  # zlib1g-dev libbz2-dev liblzma-dev libjpeg62 libjpeg62-turbo-dev

# RUN mkdir /venv
# RUN python3 -m venv /venv
# RUN source /venv/bin/activate

COPY --chown=odoo:odoo ./requirements.txt /mnt/extra-addons/requirements.txt

RUN python3 -m pip install -r /mnt/extra-addons/requirements.txt

RUN apt remove -y build-essential python3-dev python3-wheel libffi-dev rustc \
  && apt autoremove -y \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

# FROM odoo:13
# USER root

# COPY --from=build /venv /venv
# RUN source /venv/bin/activate

RUN groupmod -g 1000 odoo && usermod -u 1000 -g 1000 odoo

USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]
