import pytest
import subprocess


def test_help():
    output = subprocess.run(
        "bin/mosuite-nxf --help", capture_output=True, shell=True, text=True
    ).stdout
    assert "MOSuite-nxf" in output


def test_version():
    output = subprocess.run(
        "bin/mosuite-nxf --version", capture_output=True, shell=True, text=True
    ).stdout
    assert "mosuite-nxf, version " in output


def test_citation():
    output = subprocess.run(
        "bin/mosuite-nxf --citation", capture_output=True, shell=True, text=True
    ).stdout
    assert "@misc{" in output


def test_subcommands_help():
    assert all(
        [
            f"mosuite-nxf {cmd} [OPTIONS]"
            in subprocess.run(
                f"bin/mosuite-nxf {cmd} --help",
                capture_output=True,
                shell=True,
                text=True,
            ).stdout
            for cmd in ["run", "init"]
        ]
    )
