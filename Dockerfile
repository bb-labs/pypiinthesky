FROM python:3.9

COPY action.sh /action.sh

ENTRYPOINT ["/action.sh"]