import unittest
import subprocess

exec = "./cf-param-env.py"


class TestParamEnv(unittest.TestCase):
    def test_base_cf(self):
        args = [exec, "TestA", "TestB"]
        env = {"TEST_A": "t a", "TEST_B": "t b"}
        process = subprocess.run(args, env=env, stdout=subprocess.PIPE)
        self.assertEqual(process.returncode, 0)
        self.assertEqual(process.stdout, b"TestA='t a' TestB='t b' ")

    def test_base_sam(self):
        args = [exec, "--sam", "TestA", "TestB"]
        env = {"TEST_A": "t a", "TEST_B": "t b"}
        process = subprocess.run(args, env=env, stdout=subprocess.PIPE)
        self.assertEqual(process.returncode, 0)
        self.assertEqual(
            process.stdout,
            b"ParameterKey=TestA,ParameterValue='t a' ParameterKey=TestB,ParameterValue='t b' ",
        )

    def test_empty(self):
        args = [exec, "Empty"]
        env = {}
        process = subprocess.run(args, env=env, stdout=subprocess.PIPE)
        self.assertEqual(process.returncode, 0)
        self.assertEqual(process.stdout, b"Empty='' ")

    def test_url_chars(self):
        args = [exec, "TestA"]
        env = {"TEST_A": "mongodb://host:1234/foo?a=b&c=d"}
        process = subprocess.run(args, env=env, stdout=subprocess.PIPE)
        self.assertEqual(process.returncode, 0)
        self.assertEqual(process.stdout, b"TestA='mongodb://host:1234/foo?a=b&c=d' ")


if __name__ == "__main__":
    unittest.main()
