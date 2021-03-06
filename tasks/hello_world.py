import luigi

BASE_PATH = '/home/luigi/tasks/result'

class HelloTask(luigi.Task):
    """Writes "hello" to hello.txt file"""
    def run(self):
        with self.output().open('w') as f:
            f.write('hello')

    def output(self):
        return luigi.LocalTarget(f'{BASE_PATH}/hello.txt')


class WorldTask(luigi.Task):
    """Writes "world" to world.txt file"""
    def run(self):
        with self.output().open('w') as f:
            f.write('world')

    def output(self):
        return luigi.LocalTarget(f'{BASE_PATH}/world.txt')


class HelloWorldTask(luigi.Task):
    """Combines two previous tasks execution and write the result to hello_world.txt"""
    def requires(self):
        return [
            HelloTask(),
            WorldTask(),
        ]

    def run(self):
        hello, world = self.input()

        with self.output().open('w') as output:
            with hello.open() as fh, world.open() as fw:
                output.write('{} {}\n'.format(fh.read(), fw.read()))

    def output(self):
        return luigi.LocalTarget(f'{BASE_PATH}/hello_world.txt')

if __name__ == "__main__":
	luigi.run()
