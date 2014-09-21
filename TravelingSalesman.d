import std.stdio;
import std.file;
import std.string;
import std.array;
import std.conv;
import std.random;
import Graph;
import Vertex;
import Edge;


/**
 * Author: Harry Allen
 * Date: September 20, 2014
 *
 * This program utilizes a genetic algorithm to generate a good solution for the classic Traveling Salesman problem, and will
 * report the best solution generated, excluding the start/end vertex which is always the first vertex in the list, and its corresponding cost.
 * Accepts 4 arguments: a .txt file containing a list of the cities, a .txt file containing the distance between all cities,
 * the desired size of the population of possible solutions, and the number of generations to iterate through.
 *
 * Examples:
 * -----------------
 * rdmd Travelingsalesman.d cities.txt city_mileage.txt 2000 50
 * -----------------
 */
void main(string[] args)
{
    File file;
    Graph graph;
    int maxPopulationSize = 0;
    int generations = 0;

    if(args.length < 5)
    {
        writeln("Program requires 4 arguments:\n- .txt file containing nodes\r\n- .txt file containing edges.\r\n- Population size\r\n- Number of generations");
        return;
    }

    else
    {
        try
        {
            maxPopulationSize = parse!int(args[3]);
            generations = parse!int(args[4]);
        }
        catch(ConvException e)
        {
            writeln("Invalid argument: 3rd & 4th arguments must be integers.");
            return;
        }

        if(!exists(args[1]))
        {
            writeln("File ", args[1], " does not exist.");
            return;
        }

        else if(!exists(args[2]))
        {
            writeln("File ", args[2], " does not exist.");
            return;
        }

        else
        {
            file = File(args[1], "r");
        }
    }

    int numvertices = 0;
    string[] vertexnames;

    while(!file.eof())
    {
        string line = chomp(file.readln());

        if(line != null)
        {
            vertexnames ~= line;
            ++numvertices;
        }
    }

    graph = new Graph(vertexnames.length);
    file.close();

    for(int i=0; i < vertexnames.length; ++i)
    {
        graph.addVertex(vertexnames[i]);
    }

    file = File(args[2], "r");

    while(!file.eof())
    {
        string line = chomp(file.readln());

        if(line != null)
        {
            string[] tokens = split(line);
            graph.addEdge(tokens[0], tokens[1], parse!int(tokens[2]));
        }
    }

    file.close();

    int[][] population;
    double[] fitness;

    graph.geneticAlgorithm(maxPopulationSize, generations, population, fitness);

    graph.insertionSort(population, fitness);
    writeln("Best path generated: ", population[0], "\r\nCost: ", -fitness[0]);
}