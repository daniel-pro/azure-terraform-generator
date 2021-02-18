'''
Created on Feb 24, 2020
@author: Daniel Procopio
@summary: This program invokes the class that generates a config file
          from a jinja2 template and a YAML config file to generate
          appropriate Terraform files for OCI
@version: 1.0
'''

import argparse
from jinja2cfg import config
import logging
import os
import sys


def generateconfig(args):
    if not os.path.exists(args.output_tf_dir):
        os.makedirs(args.output_tf_dir)
    for file in os.listdir(args.input_tf_templates_dir):
        newconfig = config.Cfg(args.input_yaml,
                               os.path.join(args.input_tf_templates_dir,
                                            file),
                               os.path.join(args.output_tf_dir,
                                            file))
        newconfig.generate()
        logger.info(newconfig.getGeneratedCfg())
        logger.info("Done")


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers()

    logging.basicConfig(level=logging.DEBUG,
                        format='%(asctime)s [%(name)-9s] [%(levelname)-8s]'
                               '- %(message)s',
                        datefmt='%Y-%m-%d %H:%M')
    logger = logging.getLogger('genAZtfcli')

    main_parser = subparsers.add_parser('gentf')
    main_parser.add_argument('input_yaml', help='YAML file contaning the'
                                                ' configuraton data')
    main_parser.add_argument('input_tf_templates_dir', help='Jinja2 terraform '
                             'template directory')
    main_parser.add_argument('output_tf_dir', help='Generated Terraform '
                             'directory',
                             default='')
    main_parser.set_defaults(func=generateconfig)

    args = parser.parse_args()
    if len(sys.argv) > 1:
        args.func(args)
    else:
        logger.critical("Missing arguments")
        main_parser.print_help()
