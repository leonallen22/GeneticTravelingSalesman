import std.stdio;
import std.conv;
import std.random;
import Vertex;
import Edge;

/**
 * Author: Harry Allen
 * Date: September 20, 2014
 * 
 * A general graph data structure using an adjacency matrix to store the value of edges.
 */
public class Graph
{
    private int maxVertices;        ///Maximum number of vertices in graph
    private int numItems;           ///Current number of vertices in graph
    private Vertex[] vertices;      ///Array of vertices
    private double[][] adjMatrix;   ///Adjacency matrix containing the value of all edges

    /**
     * Empty constructor.
     */
    public this(){}
    
    /**
     * Constructor accepting the max number of vertices allowed.
     */
    public this(int maxVertices)
    {
        numItems = 0;
        this.maxVertices = maxVertices;

        adjMatrix = new double[][](maxVertices, maxVertices);

        foreach(ref double[] row; adjMatrix)
        {
            foreach(ref double num; row)
            {
                num = 0;
            }
        }
    }

    /**
     * Returns: Number of vertices currently in graph
     */
    public int getNumItems()
    {
        return numItems;
    }

    /**
     * Returns: Maximum number of vertices allowed
     */
    public int getMaxVertices()
    {
        return maxVertices;
    }

    /**
     * Returns: Key of the vertex specified by the parameter.
     * Params: index = the desired vertex key
     */
    public string getVertex(int index)
    {
        Vertex V = vertices[index];
        return V.getKey();
    }

    /**
     * Returns: The array of all vertices.
     */
    public Vertex[] getVertices()
    {
        return vertices;
    }

    /**
     * Returns: A string representation of the adjacency matrix with
     *  rows and columns labeled by index.
     */
    public string getMatrix()
    {
        char[] matrix;

        for(int i=0; i < maxVertices; ++i)
            matrix ~= "\t".dup ~ to!string(i);

        matrix ~= "\r\n".dup;

        for(int i=0; i < maxVertices; ++i)
        {
            matrix ~= to!string(i) ~ "\t".dup;

            for(int j=0; j < maxVertices; ++j)
            {
                matrix ~= to!string(adjMatrix[i][j]) ~ "\t".dup;
            }

            matrix ~= "\n";
        }

        return matrix.idup;
    }

    /**
     * Adds a vertex with the given key to the graph.
     * Params: V = the key for the new vertex
     */
    public void addVertex(string V)
    {
        Vertex newVertex = new Vertex(V);

        vertices ~= newVertex;
        ++numItems;
    }

    /**
     * Adds the given vertex to the graph.
     * Params: V = the vertex to be added to the graph
     */
    public void addVertex(Vertex V)
    {
        vertices ~= V;
        ++numItems;
    }

    /**
     * Adds an edge to the graph.
     * Params:
     *     startvertex = the key of the vertex from which the edge begins
     *     endvertex = the key of the vertex at which the edge ends
     *     edgeweight = the weight of the edge represented as an integer
     */
    public void addEdge(string startvertex, string endvertex, int edgeweight)
    {
        int startindex = -1;
        int endindex = -1;

        Edge newedge = new Edge(edgeweight);

        for(int i=0; i < vertices.length; ++i)
        {
            string key = vertices[i].getKey();

            if(startvertex == key)
            {
                startindex = i;
                Vertex A = vertices[i];
                newedge.setSource(A);
                A.setIndex(startindex);
            }

            else if(endvertex == key)
            {
                endindex = i;
                Vertex B = vertices[i];
                newedge.setSource(B);
                B.setIndex(endindex);
            }

            if(startindex != -1 && endindex != -1)
            {
                break;
            }
        }

        if(startindex != -1 && endindex != -1)
        {
            adjMatrix[startindex][endindex] = edgeweight;
            vertices[startindex].addEdge(newedge);
        }
    }

    /**
     * The genetic algorithm which initializes the population with random possible solutions,
     * then iterates through each generation by preserving the best 10 solutions and using 
     * the remaining paths as parents for crossover which will fill the remaining positions
     * in the next generation.
     *
     * Params:
     *     maxpopulationsize = the number of paths generated for each population
     *     generations = the number of generations to iterate through
     *     population = 2 dimensional array to store each generation's population
     *     fitness = array of the fitness values for each possible solution
     */
    public void geneticAlgorithm(int maxpopulationsize, int generations, ref int[][] population, ref double[] fitness)
    {
        for(int populationSize=0; populationSize < maxpopulationsize; ++populationSize)
        {
            int[] path;
            int vertex = 0;
            int next = 0;
            bool done = false;

            while(!done)
            {
                while(true)
                {
                    next = uniform(1, maxVertices);

                    if(vertex == next)
                        continue;

                    else if(adjMatrix[vertex][next] == 0)
                        continue;

                    else if(vertices[next].isMarked())
                        continue;

                    else
                        break;
                }

                vertices[next].setMarked(true);
                path ~= next;
                vertex = next;

                int marked = 0;

                foreach(Vertex v; vertices)
                {
                    if(v.isMarked())
                        ++marked;
                }
                
                if(marked == maxVertices-1)
                {
                    vertices[0].setMarked(true);
                    done = true;
                }
            }

            population ~= path;

            foreach(Vertex v; vertices)
                v.setMarked(false);
        }

        fitness = calculateFitness(population);
        insertionSort(population, fitness);

        for(int i=0; i < generations; ++i)
        {
            population = nextGeneration(population, fitness);
            fitness = calculateFitness(population);
            insertionSort(population, fitness);
        }
    }

    /**
     * Generates the next generation of the population given
     * Params:
     *     population = the population to derive the next generation from
     *     fitness = the fitness values for the population
     *
     * Returns: A new generation derived from the given population
     */
    private int[][] nextGeneration(int[][] population, double[] fitness)
    {
        int[][] nextGeneration;
        double[] nextGenerationFitness;

        if(population.length >= 10)
        {
            for(int i=0; i < 10; ++i)
            {
                nextGeneration ~= population[i];
                nextGenerationFitness ~= fitness[i];
            }
        }

        else
        {
            for(int i=0; i < population.length; ++i)
            {
                nextGeneration ~= population[i];
                nextGenerationFitness ~= fitness[i];
            }
        }

        while(nextGeneration.length != population.length)
        {
            int[][] randompaths;
            double[] randompathsfitness;


            for(int i=0; i < 10; ++i)
            {
                int randompath = uniform(10, population.length);

                if(randompaths.length > 0)
                {
                    bool isdup = false;
                    int iterations = 20;

                    do
                    {

                        if(isdup)
                        {
                            randompath = uniform(10, population.length);
                            isdup = false;
                        }

                        for(int j=0; j < randompaths.length; ++j)
                        {
                            int[] newpath = population[randompath];
                            int[] path = randompaths[j];

                            if(!isdup)
                            {
                                isdup = checkDuplicate(newpath, path);
                            }

                            else
                            {
                                break;
                            }
                        }

                        --iterations;

                    } while(isdup && iterations);

                    randompaths ~= population[randompath];
                    randompathsfitness ~= fitness[randompath];
                }

                else
                {
                    randompaths ~= population[randompath];
                    randompathsfitness ~= fitness[randompath];
                }
            }

            insertionSort(randompaths, randompathsfitness);

            randompaths.length = 4;
            randompathsfitness.length = 4;

            int[] firstpath;
            int[] secondpath;

            int firstrand = uniform(0, 4);
            int secondrand;

            do
            {
                secondrand = uniform(0, 4);

            } while(firstrand == secondrand);

            firstpath = randompaths[firstrand];
            secondpath = randompaths[secondrand];

            nextGeneration ~= crossover(firstpath, secondpath);
        }

        return nextGeneration;
    }

    /**
     * Generates a path by randomly selecting a crossover point, copying the section
     * of the path precending the crossover point from firstchrom and the section
     * succeeding the crossover point from secondchrom, and replacing duplicate visits
     * with vertices that have not been visited by the resulting path.
     *
     * Params:
     *     firstchrom = the first chromosome from which the function will derive a new path
     *     secondchrom = the second chromosome from which the function will derive a new path
     *
     * Returns: A new path generated from firstchrom and secondchrom represented as an array of integers.
     */
    private int[] crossover(int[] firstchrom, int[] secondchrom)
    {
        int chromsize = firstchrom.length;
        int crossoverpoint = uniform(1, chromsize-1);
        int[] newchrom = firstchrom[0..crossoverpoint] ~ secondchrom[crossoverpoint..chromsize];
        bool[] vertexvisited;
        bool[] vertexduplicate;

        for(int i=0; i < chromsize; ++i)
        {
            vertexvisited ~= false;
            vertexduplicate ~= false;
        }

        for(int i=0; i < chromsize; ++i)
        {
            int vertex = newchrom[i]-1;

            if(!vertexvisited[vertex])
            {
                vertexvisited[vertex] = true;
            }

            else
            {
                vertexduplicate[i] = true;
            }
        }

        for(int i=0; i < chromsize; ++i)
        {
            if(vertexduplicate[i])
            {
                int replacement = -1;
                int j = 0;

                while(replacement < 0)
                {
                    if(!vertexvisited[j])
                    {
                        replacement = j+1;
                        vertexvisited[j] = true;
                    }

                    ++j;
                }

                newchrom[i] = replacement;
                vertexduplicate[i] = false;
            }
        }

        return newchrom;
    }

    /**
     * Checks if the given paths are duplicates forward or reversed.
     *
     * Params:
     *     firstpath = a path to compare
     *     secondpath = a path to compare
     *
     * Returns: A bool with the value true if the given paths are duplicates, and false otherwise.
     */
    private bool checkDuplicate(int[] firstpath, int[] secondpath)
    {
        bool isdup = false;

        for(int i=0; i < firstpath.length; ++i)
        {
            if(firstpath[i] != secondpath[i])
            {
                break;
            }

            else if(i == firstpath.length-1)
            {
                isdup = true;
            }
        }
            
        if(!isdup)
        {
            int index = secondpath.length-1;

            for(int i=0; i < firstpath.length; ++i)
            {
                if(firstpath[i] != secondpath[index])
                {
                    break;
                }

                else if(i == firstpath.length-1)
                {
                    isdup = true;
                }

                --index;
            }
        }

        return isdup;
    }

    /**
     * Calculates the fitness values for all paths in a population from the edge weights between each vertex.
     *
     * Params: population = the population to generate the fitness values for
     *
     * Returns: The list of fitness values represented as an array of doubles
     */
    public double[] calculateFitness(int[][] population)
    {
        double[] fitness;

        foreach(int[] path; population)
        {
            int pathlength = path.length;
            double sum = 0;
            int vertex = 0;
            int next = 0;

            sum -= adjMatrix[0][path[0]];

            for(int i=0; i < pathlength-1; ++i)
            {
                sum -= adjMatrix[path[i]][path[i+1]];
            }

            sum -= adjMatrix[path[pathlength-1]][0];

            fitness ~= sum;
        }

        return fitness;
    }

    /**
     * Insertion Sort algorithm which sorts the given population along with the its fitness values.
     * 
     * Params:
     *     population = the population to sort
     *     fitness = the poulation's corresponding fitness values which will also be sorted
     */
    public void insertionSort(ref int[][] population, ref double[] fitness)
    {
        for(int i=1; i < population.length; ++i)
        {
            int j = i;
            double fitCompare = fitness[i];
            int[] temp = population[i];

            while(j > 0 && fitness[j-1] < fitCompare)
            {
                population[j] = population[j-1];
                fitness[j] = fitness[j-1];
                --j;
            }

            population[j] = temp;
            fitness[j] = fitCompare;
        }
    }
}